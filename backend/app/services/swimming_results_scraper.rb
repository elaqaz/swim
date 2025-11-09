require "nokogiri"
require "httpx"

class SwimmingResultsScraper
  BASE_URL = "https://www.swimmingresults.org"

  class ScraperError < StandardError; end

  def initialize(se_membership_id, last_name = nil, historic: false)
    @se_membership_id = se_membership_id
    @last_name = last_name
    @historic = historic
    @session = HTTPX.plugin(:follow_redirects)
    @rate_limit_delay = historic ? 2 : 0 # 2 seconds delay for historic mode
  end

  # Scrapes personal bests from swimmingresults.org
  # Returns array of hashes with performance data
  def scrape_personal_bests
    # URL format: personal_best.php?back=individualbestname&mode=A&name=LastName&tiref=ID
    @url = "#{BASE_URL}/individualbest/personal_best.php?back=individualbestname&mode=A&name=#{@last_name}&tiref=#{@se_membership_id}"

    response = @session.get(@url)

    unless response.status == 200
      raise ScraperError, "Failed to fetch data: HTTP #{response.status}"
    end

    doc = Nokogiri::HTML(response.body)

    # Find the PB table - typically has class or ID indicating personal bests
    # The structure may vary, so we'll look for common patterns
    performances = []

    # Find all tables with id="rankTable" (there are separate tables for LC and SC)
    tables = doc.css("table#rankTable")

    if tables.empty?
      raise ScraperError, "Could not find personal bests table in response"
    end

    # Parse each table (LC and SC)
    tables.each do |table|
      # Determine course type from the preceding <p> tag
      prev_p = table.previous_element
      course_type = if prev_p && prev_p.text.match?(/Long Course/i)
                      "LC"
      elsif prev_p && prev_p.text.match?(/Short Course/i)
                      "SC"
      else
                      next # Skip if we can't determine course type
      end

      rows = table.css("tr")

      # Skip header row
      rows[1..-1]&.each do |row|
        cells = row.css("td")
        next if cells.empty?

        # Table structure for swimmingresults.org:
        # Stroke | Time | Converted | Points | Date | Meet | Venue | License | Level

        performance = parse_row(cells, course_type)
        performances << performance if performance
      end
    end

    performances
  rescue HTTPX::Error => e
    raise ScraperError, "Network error: #{e.message}"
  rescue => e
    raise ScraperError, "Scraping error: #{e.message}"
  end

  # Scrapes all historic times for each event (not just PBs)
  # This mode is slower due to rate limiting to avoid being blocked
  def scrape_historic_times
    return scrape_personal_bests unless @historic

    Rails.logger.info("Starting historic import for SE ID #{@se_membership_id}")

    # Get the PB page to extract historic links with correct tstroke values
    pb_url = "#{BASE_URL}/individualbest/personal_best.php?back=individualbestname&mode=A&name=#{@last_name}&tiref=#{@se_membership_id}"
    response = @session.get(pb_url)

    unless response.status == 200
      raise ScraperError, "Failed to fetch PB page: HTTP #{response.status}"
    end

    doc = Nokogiri::HTML(response.body)
    all_performances = []

    # Find all links to personal_best_time_date.php
    links = doc.css('a[href*="personal_best_time_date.php"]')
    Rails.logger.info("Found #{links.count} events with historic data")

    links.each_with_index do |link, event_idx|
      href = link["href"]

      # Extract event info from the table row
      parent_row = link.ancestors("tr").first
      next unless parent_row

      cells = parent_row.css("td")
      next if cells.empty?

      event_name = cells[0]&.text&.strip
      next unless event_name

      # Parse event name to get distance and stroke
      distance_m = extract_distance(event_name)
      stroke_code = normalize_stroke(event_name)

      next unless distance_m && stroke_code

      # Extract tstroke and tcourse from URL
      tstroke = href[/tstroke=(\d+)/, 1]
      tcourse = href[/tcourse=([LS])/, 1]

      next unless tstroke && tcourse

      course_type = tcourse == "L" ? "LC" : "SC"

      # Build full URL
      url = if href.start_with?("./")
              "#{BASE_URL}/individualbest/#{href[2..-1]}"
      elsif href.start_with?("/")
              "#{BASE_URL}#{href}"
      else
              href
      end

      Rails.logger.info("Scraping historic times for #{distance_m}m #{stroke_code} (#{course_type}) - #{event_idx + 1}/#{links.count}")

      # Rate limiting - sleep before each request (except the first)
      sleep(@rate_limit_delay) if event_idx > 0 && @rate_limit_delay > 0

      begin
        response = @session.get(url)

        unless response.status == 200
          Rails.logger.warn("Failed to fetch historic data for #{stroke_code}/#{distance_m}/#{course_type}: HTTP #{response.status}")
          next
        end

        doc = Nokogiri::HTML(response.body)
        table = doc.css("table#rankTable").first

        unless table
          Rails.logger.warn("No table found for #{stroke_code}/#{distance_m}/#{course_type}")
          next
        end

        rows = table.css("tr")
        rows[1..-1]&.each do |row|
          cells = row.css("td")
          next if cells.empty?

          # Historic table structure: Time | WA Pts | Round | Date | Meet | Venue | Club | Level
          performance = parse_historic_row(cells, stroke_code, distance_m, course_type, url)
          all_performances << performance if performance
        end

      rescue => e
        Rails.logger.error("Error scraping historic data for #{stroke_code}/#{distance_m}/#{course_type}: #{e.message}")
        next
      end
    end

    Rails.logger.info("Historic import complete: #{all_performances.count} total performances")
    all_performances
  end

  private

  def parse_historic_row(cells, stroke_code, distance_m, course_type, source_url)
    return nil if cells.length < 5

    data = cells.map { |c| c.text.strip }

    # Historic table structure: Time | WA Pts | Round | Date | Meet | Venue | Club | Level
    time_str = data[0]
    date_str = data[3]
    meet_name = data[4]
    license_level = data[7] if data.length > 7

    begin
      time_seconds = TimeParser.to_seconds(time_str, distance_m: distance_m)
      date = parse_date(date_str)

      result = {
        distance_m: distance_m,
        stroke: stroke_code,
        course_type: course_type,
        time_seconds: time_seconds,
        original_time_str: time_str,
        date: date,
        meet_name: meet_name,
        source_url: source_url
      }

      result[:license_level] = license_level.to_i if license_level&.match?(/\d+/)

      result
    rescue => e
      Rails.logger.warn("Failed to parse historic row: #{data.inspect} - #{e.message}")
      nil
    end
  end

  def parse_row(cells, course_type)
    return nil if cells.length < 5

    data = cells.map { |c| c.text.strip }

    # swimmingresults.org structure:
    # [0] Stroke (e.g., "100 Freestyle")
    # [1] Time
    # [2] Converted time
    # [3] Points
    # [4] Date
    # [5] Meet
    # [6] Venue (optional)
    # [7] License (optional)
    # [8] Level (optional)

    stroke_and_distance = data[0]
    time_str = data[1]
    date_str = data[4]
    meet_name = data[5]
    license_level = data[8] if data.length > 8

    # Extract distance and stroke from first column
    distance = extract_distance(stroke_and_distance)
    stroke = normalize_stroke(stroke_and_distance)

    return nil unless distance && stroke

    begin
      time_seconds = TimeParser.to_seconds(time_str, distance_m: distance)
      date = parse_date(date_str)

      result = {
        distance_m: distance,
        stroke: stroke,
        course_type: course_type,
        time_seconds: time_seconds,
        original_time_str: time_str,
        date: date,
        meet_name: meet_name,
        source_url: @url
      }

      result[:license_level] = license_level.to_i if license_level&.match?(/\d+/)

      result
    rescue => e
      Rails.logger.warn("Failed to parse row: #{data.inspect} - #{e.message}")
      nil
    end
  end

  def extract_distance(str)
    # Extract numeric distance (50, 100, 200, etc.)
    match = str.match(/(\d+)/)
    match ? match[1].to_i : nil
  end

  def normalize_stroke(str)
    # Map various stroke names to standard codes
    str = str.upcase.strip

    case str
    when /FREESTYLE/
      "FREE"
    when /BACKSTROKE/
      "BACK"
    when /BREASTSTROKE/
      "BREAST"
    when /BUTTERFLY/
      "FLY"
    when /INDIVIDUAL.MEDLEY|IM/
      "IM"
    else
      nil
    end
  end

  def normalize_course(str)
    str = str.upcase.strip

    case str
    when /25|SHORT|SC/
      "SC"
    when /50|LONG|LC/
      "LC"
    else
      nil
    end
  end

  def parse_date(str)
    # Try common date formats
    # swimmingresults.org uses DD/MM/YY format (e.g., "29/06/25")
    formats = [ "%d/%m/%y", "%d/%m/%Y", "%d-%m-%Y", "%Y-%m-%d", "%d %b %Y", "%d %B %Y" ]

    formats.each do |format|
      begin
        return Date.strptime(str, format)
      rescue ArgumentError
        next
      end
    end

    # Fallback to Date.parse
    Date.parse(str)
  rescue ArgumentError
    nil
  end
end
