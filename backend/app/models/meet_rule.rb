class MeetRule < ApplicationRecord
  belongs_to :meeting, foreign_key: "meet_standard_set_id"

  validates :allow_sc_to_lc, :allow_lc_to_sc, inclusion: { in: [ true, false ] }

  def conversion_allowed?(from_course, to_course)
    return true if from_course == to_course
    return allow_sc_to_lc if from_course == "SC" && to_course == "LC"
    return allow_lc_to_sc if from_course == "LC" && to_course == "SC"
    false
  end

  def license_level_valid?(level)
    return true if min_license_level.nil?
    return false if level.nil?
    level >= min_license_level
  end
end
