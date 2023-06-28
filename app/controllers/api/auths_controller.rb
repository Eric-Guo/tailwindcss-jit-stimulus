# frozen_string_literal: true

module Api
  class AuthsController < ApplicationController
    skip_before_action :authenticate_any!

    def wxwork
      wechat_oauth2 do |user_name|
        raise Exception.new('获取微信用户名失败') unless user_name.present?

        redirect_uri = params[:redirect_uri]

        Current.user = User.find_by wecom_id: user_name
        Current.user = User.find_by email: "#{user_name}@thape.com.cn" if Current.user.blank?

        raise Exception.new('获取用户信息失败') unless Current.user.present?

        sign_in Current.user

        if redirect_uri.present?
          redirect_to redirect_uri
        else
          redirect_uri '/m/'
        end
      end
    end

    def logout
      sign_out(current_user) if current_user.present?

      render json: { message: '退出成功' }
    end
  end
end
