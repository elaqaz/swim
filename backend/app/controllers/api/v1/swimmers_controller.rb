module Api
  module V1
    class SwimmersController < BaseController
      before_action :set_swimmer, only: [ :show, :update, :destroy, :future_qualifications ]

      def index
        swimmers = current_user.swimmers.includes(:performances).order(:first_name, :last_name)
        render json: swimmers, include: :performances
      end

      def show
        all_performances = @swimmer.performances.order(:time_seconds)

        lc_performances = all_performances
                            .where(course_type: "LC")
                            .group_by { |p| [ p.stroke, p.distance_m ] }
                            .map { |key, perfs| perfs.min_by(&:time_seconds) }
                            .sort_by { |p| [ p.stroke, p.distance_m ] }

        sc_performances = all_performances
                            .where(course_type: "SC")
                            .group_by { |p| [ p.stroke, p.distance_m ] }
                            .map { |key, perfs| perfs.min_by(&:time_seconds) }
                            .sort_by { |p| [ p.stroke, p.distance_m ] }

        render json: {
          swimmer: @swimmer,
          lc_performances: lc_performances,
          sc_performances: sc_performances
        }
      end

      def create
        swimmer = Swimmer.new(swimmer_params)
        if swimmer.save
          current_user.swimmers << swimmer unless current_user.swimmers.include?(swimmer)
          render json: swimmer, status: :created
        else
          render_error(swimmer.errors.full_messages.join(", "))
        end
      end

      def update
        if @swimmer.update(swimmer_params)
          render json: @swimmer
        else
          render_error(@swimmer.errors.full_messages.join(", "))
        end
      end

      def destroy
        name = @swimmer.full_name
        @swimmer.destroy
        render json: { message: "#{name} has been removed." }
      end

      def future_qualifications
        # Get all future meetings (window_end >= today)
        future_meetings = Meeting.where("window_end >= ?", Date.today).order(:window_end)

        swimmer_age = @swimmer.age_on(Date.today)
        qualifications = []

        future_meetings.each do |meeting|
          meeting_age = @swimmer.age_on(meeting.age_reference_date)
          qualified_events = []

          # Get all standards for this meeting that apply to the swimmer's gender
          meeting.meeting_standards.where(gender: @swimmer.sex).each do |standard|
            # Check if the age group applies to this swimmer
            next unless standard.applies_to_age?(meeting_age)

            # Find the swimmer's best performance for this event
            perf_query = @swimmer.performances
              .where(stroke: standard.stroke, distance_m: standard.distance_m)

            # Filter by window_end if it exists
            perf_query = perf_query.where("date <= ?", meeting.window_end) if meeting.window_end.present?

            best_perf = perf_query.order(:time_seconds).first
            next unless best_perf

            # Get the appropriate time (LC or SC based on pool_required)
            swimmer_time = if meeting.pool_required == "LC"
              best_perf.lc_time_seconds || best_perf.time_seconds
            else
              best_perf.sc_time_seconds || best_perf.time_seconds
            end

            # Check if they qualify
            if swimmer_time && swimmer_time <= standard.qualifying_time_seconds
              qualified_events << {
                stroke: standard.stroke,
                distance_m: standard.distance_m,
                course_type: standard.course_type,
                swimmer_time: swimmer_time,
                swimmer_time_formatted: TimeParser.to_formatted(swimmer_time),
                qualifying_time: standard.qualifying_time_seconds,
                qualifying_time_formatted: standard.qualifying_time,
                time_difference: swimmer_time - standard.qualifying_time_seconds,
                original_course: best_perf.course_type,
                converted: best_perf.course_type != meeting.pool_required
              }
            end
          end

          if qualified_events.any?
            qualifications << {
              meeting_id: meeting.id,
              meeting_name: meeting.name,
              season: meeting.season,
              pool_required: meeting.pool_required,
              window_start: meeting.window_start,
              window_end: meeting.window_end,
              qualified_events: qualified_events,
              total_events: qualified_events.size
            }
          end
        end

        render json: {
          swimmer: @swimmer,
          swimmer_age: swimmer_age,
          qualifications: qualifications,
          total_meetings: qualifications.size,
          total_events: qualifications.sum { |q| q[:total_events] }
        }
      end

      private

      def set_swimmer
        @swimmer = current_user.swimmers.find_by!(se_membership_id: params[:id])
      end

      def swimmer_params
        params.require(:swimmer).permit(:first_name, :last_name, :dob, :sex, :club, :se_membership_id)
      end
    end
  end
end
