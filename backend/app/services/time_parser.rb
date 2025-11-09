class TimeParser
  # Parse swim time strings like "1:05.23", "65.23", "1:05" into seconds
  # distance_m: optional distance in meters to help validate and correct parsing
  def self.to_seconds(str, distance_m: nil)
    return nil if str.nil? || str.to_s.strip.empty?

    str = str.to_s.strip

    # Handle format: "M:SS.hh" or "MM:SS.hh"
    if str.include?(":")
      parts = str.split(":", 2)
      mins = parts[0].to_i
      secs = parts[1].to_f
      total_seconds = (mins * 60 + secs).round(2)

      # Validate and correct based on distance if provided
      # For 50m events, times should typically be under 90 seconds
      # If we get something like "6:39.73" (399.73s) for 50m, it's likely "39.73"
      if distance_m == 50 && total_seconds > 90
        # Try removing the first digit from minutes and re-parsing
        # "6:39.73" -> "39.73"
        corrected_str = parts[1]
        Rails.logger.warn("TimeParser: Correcting likely malformed time '#{str}' to '#{corrected_str}' for #{distance_m}m event")
        return corrected_str.to_f.round(2)
      elsif distance_m == 100 && total_seconds > 180
        # For 100m, times over 3 minutes are suspicious
        corrected_str = parts[1]
        Rails.logger.warn("TimeParser: Correcting likely malformed time '#{str}' to '#{corrected_str}' for #{distance_m}m event")
        return corrected_str.to_f.round(2)
      elsif distance_m == 200 && total_seconds > 360
        # For 200m, times over 6 minutes are suspicious
        corrected_str = parts[1]
        Rails.logger.warn("TimeParser: Correcting likely malformed time '#{str}' to '#{corrected_str}' for #{distance_m}m event")
        return corrected_str.to_f.round(2)
      end

      return total_seconds
    end

    # Handle format: "SS.hh" or just "SS"
    str.to_f.round(2)
  end

  # Convert seconds to formatted string "M:SS.hh"
  def self.to_formatted(seconds)
    return nil if seconds.nil?

    seconds = seconds.to_f
    mins = (seconds / 60).to_i
    secs = seconds % 60

    if mins > 0
      format("%d:%05.2f", mins, secs)
    else
      format("%.2f", secs)
    end
  end
end
