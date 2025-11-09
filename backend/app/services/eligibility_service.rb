class EligibilityService
  # Result struct for eligibility check
  Result = Struct.new(
    :best_time,
    :best_course,
    :conversion_used,
    :license_level,
    :provenance,
    :required,
    :consider,
    :delta_to_qualify,
    :qualified,
    :consideration,
    keyword_init: true
  )

  def initialize(swimmer:, set:, rules: nil, date_override: nil)
    @swimmer = swimmer
    @set = set
    @rules = rules || set.meet_rule
    @age_date = compute_age_date(date_override)
  end

  # Check eligibility for a specific event
  # @param stroke [String] stroke name
  # @param distance_m [Integer] distance in meters
  # @return [Result, nil] eligibility result or nil if no standards found
  def check(stroke:, distance_m:)
    age = age_on(@age_date, @swimmer.dob)

    # Find qualifying and consideration standards
    std_row_q = find_standard_row(stroke, distance_m, age, type: "QUALIFY")
    std_row_c = find_standard_row(stroke, distance_m, age, type: "CONSIDER")

    return nil unless std_row_q || std_row_c

    # Get eligible performances and find best
    eligible = filter_performances(stroke, distance_m)
    candidates = eligible.map { |p| candidate_from_performance(p, stroke, distance_m) }.compact
    best = candidates.min_by { |c| c[:time] }

    return nil unless best

    required = std_row_q&.time_seconds
    consider = std_row_c&.time_seconds
    delta = required ? (best[:time] - required).round(2) : nil

    Result.new(
      best_time: best[:time],
      best_course: best[:course],
      conversion_used: best[:conv],
      license_level: best[:license_level],
      provenance: best[:prov],
      required: required,
      consider: consider,
      delta_to_qualify: delta,
      qualified: required && best[:time] <= required,
      consideration: consider && !required || (consider && best[:time] > required && best[:time] <= consider)
    )
  end

  private

  def compute_age_date(override)
    return override.to_date if override
    return @set.age_rule_date if @set.age_rule_type == "AGE_AT_DATE" && @set.age_rule_date.present?

    Date.new(@set.window_end&.year || Date.today.year, 12, 31)
  end

  def age_on(date, dob)
    age = date.year - dob.year
    age -= 1 if date.yday < dob.yday
    age
  end

  def find_standard_row(stroke, distance_m, age, type:)
    @set.meeting_standards
        .where(stroke: stroke, distance_m: distance_m, standard_type: type)
        .where("age_min IS NULL OR age_min <= ?", age)
        .where("age_max IS NULL OR age_max >= ?", age)
        .first
  end

  def filter_performances(stroke, distance_m)
    scope = @swimmer.performances.where(stroke: stroke, distance_m: distance_m)

    # Apply qualifying window
    if @set.window_start && @set.window_end
      scope = scope.where(date: @set.window_start..@set.window_end)
    end

    # Apply license level filter
    if @rules&.min_license_level.present?
      scope = scope.where("license_level >= ?", @rules.min_license_level)
    end

    scope
  end

  def candidate_from_performance(performance, stroke, distance_m)
    target_course = @set.pool_required

    if %w[LC SC].include?(target_course)
      if performance.course_type == target_course
        # No conversion needed
        time = performance.time_seconds.to_f
        conv = false
      else
        # Check if conversion is allowed
        return nil unless conversion_allowed?(performance.course_type, target_course)

        # Convert the time
        time = EquivalentTime.convert(
          stroke: stroke,
          distance_m: distance_m,
          from_course: performance.course_type,
          to_course: target_course,
          time_seconds: performance.time_seconds.to_f
        )
        conv = true
      end
      course = target_course
    else
      # Either course accepted
      time = performance.time_seconds.to_f
      conv = false
      course = performance.course_type
    end

    {
      time: time,
      course: course,
      conv: conv,
      license_level: performance.license_level,
      prov: {
        meet_name: performance.meet_name,
        date: performance.date,
        source_url: performance.source_url,
        original_course: performance.course_type,
        original_time: performance.time_seconds.to_f
      }
    }
  end

  def conversion_allowed?(from, to)
    return true if from == to
    return false unless @rules

    @rules.conversion_allowed?(from, to)
  end
end
