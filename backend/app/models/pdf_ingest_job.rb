class PdfIngestJob < ApplicationRecord
  validates :status, inclusion: { in: %w[PENDING PARSED FAILED NEEDS_REVIEW] }, allow_nil: true

  def mark_parsed!(json, confidence_score)
    update!(
      status: "PARSED",
      parsed_json: json,
      confidence: confidence_score
    )
  end

  def mark_failed!
    update!(status: "FAILED")
  end

  def needs_review?
    confidence.present? && confidence < 0.85
  end
end
