# frozen_string_literal: true

module Api
  class ApplicationController < ActionController::API
    include ActionController::Helpers
    helper ApplicationHelper
    include ActionController::Cookies
    wechat_api
    before_action :authenticate_user!
    before_action :login_in_as_dev_user, if: -> { Rails.env.development? }
    after_action :record_user_view_history, if: -> { Rails.env.production? }

    def pagination_params
      page = params[:page].to_i > 0 ? params[:page].to_i : 1
      page_size = params[:page_size].to_i > 0 ? params[:page_size].to_i : 10
      [page, page_size]
    end

    private

      def login_in_as_dev_user
        sign_in User.where('clerk_code = ?', '019795').first unless user_signed_in?
      end

      def record_user_view_history
        ReportViewHistory.create(controller_name: controller_path, action_name: action_name,
          clerk_code: current_user&.clerk_code, request_path: request.fullpath)
      end
  end
end
