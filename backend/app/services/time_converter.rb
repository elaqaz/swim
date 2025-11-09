class TimeConverter
  # Conversion factors based on distance and stroke
  # These are approximate conversions based on turn times (SC is typically faster due to more turns)
  # Format: { distance_m => { stroke => percentage_difference } }
  # Negative means SC is faster (typical case)

  CONVERSION_FACTORS = {
    50 => {
      "FREE" => 0.0,      # No conversion for 50m (only 1 turn)
      "BACK" => 0.0,
      "BREAST" => 0.0,
      "FLY" => 0.0,
      "IM" => 0.0
    },
    100 => {
      "FREE" => -0.015,    # SC ~1.5% faster
      "BACK" => -0.020,    # SC ~2% faster
      "BREAST" => -0.025,  # SC ~2.5% faster
      "FLY" => -0.020,     # SC ~2% faster
      "IM" => -0.020
    },
    200 => {
      "FREE" => -0.025,    # SC ~2.5% faster
      "BACK" => -0.030,    # SC ~3% faster
      "BREAST" => -0.035,  # SC ~3.5% faster
      "FLY" => -0.030,     # SC ~3% faster
      "IM" => -0.030
    },
    400 => {
      "FREE" => -0.030,    # SC ~3% faster
      "BACK" => -0.035,
      "BREAST" => -0.040,
      "FLY" => -0.035,
      "IM" => -0.035
    },
    800 => {
      "FREE" => -0.035,    # SC ~3.5% faster
      "BACK" => -0.040,
      "BREAST" => -0.045,
      "FLY" => -0.040,
      "IM" => -0.040
    },
    1500 => {
      "FREE" => -0.040,    # SC ~4% faster
      "BACK" => -0.045,
      "BREAST" => -0.050,
      "FLY" => -0.045,
      "IM" => -0.045
    }
  }.freeze

  # Convert LC time to SC time
  # @param lc_time_seconds [Float] Time in long course
  # @param distance_m [Integer] Distance in meters
  # @param stroke [String] Stroke type
  # @return [Float] Estimated SC time
  def self.lc_to_sc(lc_time_seconds, distance_m, stroke)
    return lc_time_seconds if lc_time_seconds.nil?

    factor = get_conversion_factor(distance_m, stroke)
    # Negative factor means SC is faster, so we multiply by (1 + factor)
    # For example, -0.015 means SC is 1.5% faster, so SC time = LC time * 0.985
    lc_time_seconds * (1.0 + factor)
  end

  # Convert SC time to LC time
  # @param sc_time_seconds [Float] Time in short course
  # @param distance_m [Integer] Distance in meters
  # @param stroke [String] Stroke type
  # @return [Float] Estimated LC time
  def self.sc_to_lc(sc_time_seconds, distance_m, stroke)
    return sc_time_seconds if sc_time_seconds.nil?

    factor = get_conversion_factor(distance_m, stroke)
    # Reverse the conversion
    sc_time_seconds / (1.0 + factor)
  end

  # Get the appropriate time for a given course type
  # @param lc_time [Float] LC time in seconds
  # @param sc_time [Float] SC time in seconds
  # @param desired_course [String] 'LC' or 'SC'
  # @return [Float] Time in the desired course
  def self.get_time_for_course(lc_time, sc_time, desired_course)
    case desired_course
    when "LC"
      lc_time
    when "SC"
      sc_time
    else
      # Default to whichever is available
      lc_time || sc_time
    end
  end

  private

  def self.get_conversion_factor(distance_m, stroke)
    # Get factor for this distance/stroke combination
    distance_factors = CONVERSION_FACTORS[distance_m]
    return 0.0 unless distance_factors

    distance_factors[stroke] || 0.0
  end
end
