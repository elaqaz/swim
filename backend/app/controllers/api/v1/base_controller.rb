module Api
  module V1
    class BaseController < ApplicationController
      before_action :authenticate_user!

      respond_to :json

      private

      def render_error(message, status = :unprocessable_entity)
        render json: { error: message }, status: status
      end

      def render_success(data, status = :ok)
        render json: data, status: status
      end
    end
  end
end
