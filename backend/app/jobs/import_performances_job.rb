class ImportPerformancesJob
  include Sidekiq::Job

  def perform(swimmer_id, historic = false)
    swimmer = Swimmer.find(swimmer_id)

    unless swimmer.se_membership_id.present?
      Rails.logger.error("Swimmer #{swimmer_id} has no SE membership ID")
      return
    end

    scraper = SwimmingResultsScraper.new(swimmer.se_membership_id, swimmer.last_name, historic: historic)

    begin
      performances_data = historic ? scraper.scrape_historic_times : scraper.scrape_personal_bests

      Rails.logger.info("Scraped #{performances_data.length} performances for swimmer #{swimmer_id}")

      imported_count = 0
      skipped_count = 0
      error_count = 0

      performances_data.each do |perf_data|
        # Check if this performance already exists
        existing = swimmer.performances.find_by(
          stroke: perf_data[:stroke],
          distance_m: perf_data[:distance_m],
          course_type: perf_data[:course_type],
          date: perf_data[:date],
          time_seconds: perf_data[:time_seconds]
        )

        if existing
          skipped_count += 1
          next
        end

        # Create new performance with both LC and SC times
        performance = swimmer.performances.build(perf_data)

        # Calculate both LC and SC times using conversion
        if perf_data[:course_type] == "LC"
          performance.lc_time_seconds = perf_data[:time_seconds]
          performance.sc_time_seconds = TimeConverter.lc_to_sc(
            perf_data[:time_seconds],
            perf_data[:distance_m],
            perf_data[:stroke]
          )
        else # SC
          performance.sc_time_seconds = perf_data[:time_seconds]
          performance.lc_time_seconds = TimeConverter.sc_to_lc(
            perf_data[:time_seconds],
            perf_data[:distance_m],
            perf_data[:stroke]
          )
        end

        if performance.save
          imported_count += 1
        else
          error_count += 1
          Rails.logger.warn("Failed to save performance: #{performance.errors.full_messages.join(', ')}")
        end
      end

      Rails.logger.info("Import complete for swimmer #{swimmer_id}: #{imported_count} imported, #{skipped_count} skipped, #{error_count} errors")

      # Update swimmer's last import timestamp
      swimmer.update(updated_at: Time.current)

    rescue SwimmingResultsScraper::ScraperError => e
      Rails.logger.error("Scraping failed for swimmer #{swimmer_id}: #{e.message}")
      raise
    end
  end
end
