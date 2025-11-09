class EquivalentTime
  # SC to LC and LC to SC conversion factors
  # Based on typical conversion ratios (can be calibrated with official tables)
  CONVERSION_FACTORS = {
    # FREE
    [ "FREE", 50, "SC", "LC" ] => 1.008,
    [ "FREE", 50, "LC", "SC" ] => 0.992,
    [ "FREE", 100, "SC", "LC" ] => 1.010,
    [ "FREE", 100, "LC", "SC" ] => 0.990,
    [ "FREE", 200, "SC", "LC" ] => 1.012,
    [ "FREE", 200, "LC", "SC" ] => 0.988,
    [ "FREE", 400, "SC", "LC" ] => 1.014,
    [ "FREE", 400, "LC", "SC" ] => 0.986,
    [ "FREE", 800, "SC", "LC" ] => 1.015,
    [ "FREE", 800, "LC", "SC" ] => 0.985,
    [ "FREE", 1500, "SC", "LC" ] => 1.016,
    [ "FREE", 1500, "LC", "SC" ] => 0.984,

    # BACK
    [ "BACK", 50, "SC", "LC" ] => 1.010,
    [ "BACK", 50, "LC", "SC" ] => 0.990,
    [ "BACK", 100, "SC", "LC" ] => 1.012,
    [ "BACK", 100, "LC", "SC" ] => 0.988,
    [ "BACK", 200, "SC", "LC" ] => 1.014,
    [ "BACK", 200, "LC", "SC" ] => 0.986,

    # BREAST
    [ "BREAST", 50, "SC", "LC" ] => 1.008,
    [ "BREAST", 50, "LC", "SC" ] => 0.992,
    [ "BREAST", 100, "SC", "LC" ] => 1.010,
    [ "BREAST", 100, "LC", "SC" ] => 0.990,
    [ "BREAST", 200, "SC", "LC" ] => 1.012,
    [ "BREAST", 200, "LC", "SC" ] => 0.988,

    # FLY
    [ "FLY", 50, "SC", "LC" ] => 1.009,
    [ "FLY", 50, "LC", "SC" ] => 0.991,
    [ "FLY", 100, "SC", "LC" ] => 1.011,
    [ "FLY", 100, "LC", "SC" ] => 0.989,
    [ "FLY", 200, "SC", "LC" ] => 1.013,
    [ "FLY", 200, "LC", "SC" ] => 0.987,

    # IM
    [ "IM", 100, "SC", "LC" ] => 1.011,
    [ "IM", 100, "LC", "SC" ] => 0.989,
    [ "IM", 200, "SC", "LC" ] => 1.013,
    [ "IM", 200, "LC", "SC" ] => 0.987,
    [ "IM", 400, "SC", "LC" ] => 1.015,
    [ "IM", 400, "LC", "SC" ] => 0.985
  }.freeze

  # Convert time between courses
  # @param stroke [String] stroke name (FREE, BACK, BREAST, FLY, IM)
  # @param distance_m [Integer] distance in meters
  # @param from_course [String] source course (SC or LC)
  # @param to_course [String] target course (SC or LC)
  # @param time_seconds [Float] time in seconds
  # @return [Float] converted time in seconds
  def self.convert(stroke:, distance_m:, from_course:, to_course:, time_seconds:)
    return time_seconds if from_course == to_course

    factor = lookup_factor(stroke, distance_m, from_course, to_course)
    (time_seconds * factor).round(2)
  end

  # Look up conversion factor
  def self.lookup_factor(stroke, distance_m, from_course, to_course)
    key = [ stroke, distance_m, from_course, to_course ]
    CONVERSION_FACTORS.fetch(key, 1.0)
  end

  # Check if conversion is available
  def self.conversion_available?(stroke, distance_m, from_course, to_course)
    return true if from_course == to_course

    key = [ stroke, distance_m, from_course, to_course ]
    CONVERSION_FACTORS.key?(key)
  end
end
