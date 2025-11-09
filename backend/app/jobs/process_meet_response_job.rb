class ProcessMeetResponseJob < ApplicationJob
  queue_as :default

  def perform(parsed_meet_datum_id)
    parsed_record = ParsedMeetDatum.find(parsed_meet_datum_id)

    begin
      parsed_record.update!(status: "processing_response")

      # Get the raw LLM response
      raw_response = parsed_record.raw_response
      raise StandardError, "No raw response found" unless raw_response

      # Strip markdown code fences if present (```json ... ```)
      json_content = raw_response.strip
      if json_content.start_with?("```")
        # Remove opening fence (```json or ```)
        json_content = json_content.sub(/\A```(?:json)?\n?/, "")
        # Remove closing fence
        json_content = json_content.sub(/\n?```\z/, "")
      end

      # Parse the JSON response
      parsed_data = JSON.parse(json_content)

      # Validate the parsed data
      validate_parsed_data(parsed_data)

      # Save the validated data
      parsed_record.update!(
        status: "completed",
        data: parsed_data
      )

      # Auto-confirm the meeting
      ConfirmMeetingJob.perform_later(parsed_record.id)
    rescue => e
      parsed_record.update!(
        status: "failed",
        error_message: "Processing error: #{e.message}"
      )
      raise
    end
  end

  private

  def validate_parsed_data(data)
    required_keys = [ "meet_name", "standards" ]
    missing_keys = required_keys - data.keys

    raise StandardError, "Missing required keys: #{missing_keys.join(', ')}" if missing_keys.any?
    raise StandardError, "No standards found" if data["standards"].empty?

    # Validate each standard
    data["standards"].each_with_index do |standard, idx|
      required_standard_keys = [ "distance_m", "stroke", "course_type", "sex", "qualifying_time_seconds" ]
      missing = required_standard_keys - standard.keys

      if missing.any?
        raise StandardError, "Standard ##{idx + 1} missing keys: #{missing.join(', ')}"
      end
    end
  end
end
