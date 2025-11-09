class ParsedMeetDatum < ApplicationRecord
  # Retry processing the LLM response without calling the LLM again
  # This is useful if the processing failed due to validation errors
  def retry_processing!
    return unless raw_response.present?

    ProcessMeetResponseJob.perform_later(id)
  end
end
