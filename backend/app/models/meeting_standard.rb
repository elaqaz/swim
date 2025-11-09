class MeetingStandard < ApplicationRecord
  self.table_name = "meet_standard_rows"

  belongs_to :meeting, foreign_key: "meet_standard_set_id"

  validates :stroke, :distance_m, :pool_of_standard, :standard_type, :time_seconds, presence: true
  validates :stroke, inclusion: { in: %w[FREE BACK BREAST FLY IM] }
  validates :distance_m, inclusion: { in: [ 50, 100, 200, 400, 800, 1500 ] }

  scope :for_event, ->(stroke, distance_m) { where(stroke: stroke, distance_m: distance_m) }
  scope :for_age, ->(age) do
    where("(age_min IS NULL OR age_min <= ?) AND (age_max IS NULL OR age_max >= ?)", age, age)
  end
  scope :qualifying, -> { where(standard_type: "QUALIFY") }
  scope :consideration, -> { where(standard_type: "CONSIDER") }

  def applies_to_age?(age)
    (age_min.nil? || age >= age_min) && (age_max.nil? || age <= age_max)
  end

  # Helper methods for compatibility with views
  def age_group
    if age_min && age_max
      # If min and max are the same, show single age
      if age_min == age_max
        age_min.to_s
      else
        "#{age_min}-#{age_max}"
      end
    elsif age_min
      "#{age_min}+"
    elsif age_max
      "Under #{age_max}"
    else
      "Open"
    end
  end

  def sex
    gender
  end

  def course_type
    pool_of_standard
  end

  def qualifying_time_seconds
    time_seconds
  end

  def qualifying_time
    TimeParser.to_formatted(time_seconds)
  end
end
