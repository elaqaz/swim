module Api
  module V1
    class DashboardController < BaseController
      def index
        swimmers = current_user.swimmers.includes(:performances)
        meetings = Meeting.all
        recent_performances = Performance.joins(:swimmer)
                                          .merge(current_user.swimmers)
                                          .order(date: :desc)
                                          .limit(10)
        stats = {
          total_swimmers: current_user.swimmers.count,
          total_performances: Performance.joins(:swimmer).merge(current_user.swimmers).count,
          total_meets: Meeting.count
        }

        render json: {
          swimmers: swimmers,
          meetings: meetings,
          recent_performances: recent_performances,
          stats: stats
        }
      end
    end
  end
end
