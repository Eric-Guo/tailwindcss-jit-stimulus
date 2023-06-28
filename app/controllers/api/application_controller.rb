# frozen_string_literal: true

module Api
  class ApplicationController < ActionController::API
    include ActionController::Helpers
    helper ApplicationHelper
    include ActionController::Cookies
    wechat_api
    before_action :authenticate_any!
    after_action :record_user_view_history, if: -> { Rails.env.production? }

    def pagination_params
      page = params[:page].to_i > 0 ? params[:page].to_i : 1
      page_size = params[:page_size].to_i > 0 ? params[:page_size].to_i : 10
      [page, page_size]
    end

    def authenticate_any!
      unless user_signed_in? || visitor_signed_in?
        head :unauthorized
      end
      if visitor_signed_in? && !current_visitor.effective?
        redirect_to visitor_logout_path
      end
    end

    private
      def record_user_view_history
        ReportViewHistory.create(controller_name: controller_path, action_name: action_name,
          clerk_code: current_user&.clerk_code, request_path: request.fullpath)
      end
  end
end
