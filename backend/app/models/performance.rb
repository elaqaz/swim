class Performance < ApplicationRecord
  belongs_to :swimmer

  validates :time_seconds, :date, :stroke, :distance_m, :course_type, presence: true
  validates :stroke, inclusion: { in: %w[FREE BACK BREAST FLY IM] }
  validates :distance_m, inclusion: { in: [ 50, 100, 200, 400, 800, 1500 ] }
  validates :course_type, inclusion: { in: %w[SC LC] }

  scope :in_window, ->(start_date, end_date) { where(date: start_date..end_date) if start_date && end_date }
  scope :with_min_license, ->(level) { where("license_level >= ?", level) if level.present? }
  scope :for_event, ->(stroke, distance_m) { where(stroke: stroke, distance_m: distance_m) }

  def time_formatted
    # Always format from time_seconds to ensure consistency
    # (original_time_str may contain malformed data that was corrected during import)
    mins = (time_seconds / 60).to_i
    secs = time_seconds % 60
    if mins > 0
      format("%d:%05.2f", mins, secs)
    else
      format("%.2f", secs)
    end
  end
end
