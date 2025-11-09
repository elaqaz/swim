module Api
  module V1
    class DashboardController < BaseController
      def index
        swimmers = current_user.swimmers.includes(:performances)
        meetings = Meeting.all
        recent_performances = Performance.joins(:swimmer)
                                          .merge(current_user.swimmers)
                                          .includes(:swimmer)
                                          .order(date: :desc)
                                          .limit(10)
                                          .map do |perf|
          perf.as_json.merge(
            swimmer_name: "#{perf.swimmer.first_name} #{perf.swimmer.last_name}",
            swimmer_se_id: perf.swimmer.se_membership_id
          )
        end
        stats = {
          total_swimmers: current_user.swimmers.count,
          total_performances: Performance.joins(:swimmer).merge(current_user.swimmers).count,
          total_meets: Meeting.count
        }

        # Calculate future qualifications for each swimmer
        future_meetings = Meeting.where("window_end >= ?", Date.today)
        swimmers_with_qualifications = swimmers.map do |swimmer|
          total_qualified_events = 0

          future_meetings.each do |meeting|
            swimmer_age = swimmer.age_on(meeting.age_reference_date)

            meeting.meeting_standards.where(gender: swimmer.sex).each do |standard|
              next unless standard.applies_to_age?(swimmer_age)

              perf_query = swimmer.performances
                .where(stroke: standard.stroke, distance_m: standard.distance_m)

              perf_query = perf_query.where("date <= ?", meeting.window_end) if meeting.window_end.present?

              best_perf = perf_query.order(:time_seconds).first
              next unless best_perf

              swimmer_time = if meeting.pool_required == "LC"
                best_perf.lc_time_seconds || best_perf.time_seconds
              else
                best_perf.sc_time_seconds || best_perf.time_seconds
              end

              if swimmer_time && swimmer_time <= standard.qualifying_time_seconds
                total_qualified_events += 1
              end
            end
          end

          swimmer.as_json.merge(future_qualification_count: total_qualified_events)
        end

        render json: {
          swimmers: swimmers_with_qualifications,
          meetings: meetings,
          recent_performances: recent_performances,
          stats: stats
        }
      end
    end
  end
end
