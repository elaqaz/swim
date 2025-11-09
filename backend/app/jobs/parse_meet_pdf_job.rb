class ParseMeetPdfJob < ApplicationJob
  queue_as :default

  def perform(parsed_meet_datum_id, pdf_data)
    parsed_record = ParsedMeetDatum.find(parsed_meet_datum_id)

    begin
      parsed_record.update!(status: "calling_llm")

      # Call the LLM to get raw response
      raw_response = call_llm(pdf_data)

      # Save the raw response immediately (this costs money, so we save it!)
      parsed_record.update!(
        status: "llm_complete",
        raw_response: raw_response
      )

      # Enqueue a separate job to process the response
      # This can be retried without calling the LLM again
      ProcessMeetResponseJob.perform_later(parsed_meet_datum_id)

    rescue => e
      parsed_record.update!(
        status: "failed",
        error_message: "LLM call error: #{e.message}"
      )
      raise
    end
  end

  private

  def call_llm(pdf_data)
    require "anthropic"
    require "base64"

    # Load API key
    api_key = ENV["ANTHROPIC_API_KEY"]
    if api_key.nil? || api_key.empty?
      require "dotenv"
      Dotenv.load
      api_key = ENV["ANTHROPIC_API_KEY"]
    end

    client = Anthropic::Client.new(api_key: api_key)

    base64_pdf = Base64.strict_encode64(pdf_data)
    prompt = build_parsing_prompt

    response = client.beta.messages.create(
      model: "claude-sonnet-4-5-20250929",
      max_tokens: 16000,
      betas: [ "pdfs-2024-09-25" ],
      messages: [
        {
          role: "user",
          content: [
            {
              type: "document",
              source: {
                type: "base64",
                media_type: "application/pdf",
                data: base64_pdf
              }
            },
            {
              type: "text",
              text: prompt
            }
          ]
        }
      ]
    )

    # Extract text from response
    content = response.content&.first&.text
    raise StandardError, "No response from Claude" unless content

    content
  end

  def build_parsing_prompt
    <<~PROMPT
      You are a swimming meet qualification document parser. Extract all qualification standards from this PDF.

      IMPORTANT: Return ONLY valid JSON, no markdown formatting, no code blocks, no explanation.

      Extract the following information:

      1. **Meet Information:**
         - Meet name
         - Season/year
         - Pool type required (LC/SC)
         - Qualifying window dates (start and end)
         - Age calculation method (either "age_on_date" with specific date, or "calendar_year")

      2. **Qualification Standards:**
         For each event, extract all qualifying times organized by:
         - Event (distance + stroke, e.g., "50 FREE", "100 BACK")
         - Course type (LC or SC)
         - Age groups (e.g., "10", "11", "12-13", "14-15")
         - Gender (M/F)
         - Qualifying time in seconds

      Return data in this EXACT JSON structure:

      {
        "meet_name": "string",
        "season": "string",
        "pool_required": "LC" or "SC",
        "window_start": "YYYY-MM-DD" or null,
        "window_end": "YYYY-MM-DD" or null,
        "age_calculation": {
          "method": "age_on_date" or "calendar_year",
          "date": "YYYY-MM-DD" or null
        },
        "standards": [
          {
            "distance_m": integer,
            "stroke": "FREE" or "BACK" or "BREAST" or "FLY" or "IM",
            "course_type": "LC" or "SC",
            "age_group": "string",
            "sex": "M" or "F",
            "qualifying_time_seconds": float
          }
        ]
      }

      IMPORTANT NOTES:
      - Convert all times to seconds (e.g., "1:30.45" becomes 90.45)
      - Stroke codes: FREE, BACK, BREAST, FLY, IM
      - Age groups: keep as strings (e.g., "10", "11-12", "13-14", "Open")
      - If age is calculated on a specific date, use "age_on_date" method
      - If age is based on calendar year (e.g., "age as of 31 Dec 2025"), use "calendar_year" method
      - Extract ALL standards from ALL tables in the document
      - Be careful with merged cells and complex table layouts

      Return ONLY the JSON object, nothing else.
    PROMPT
  end
end
