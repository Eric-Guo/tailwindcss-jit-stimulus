# frozen_string_literal: true

module Api
  class AuthsController < ApplicationController
    skip_before_action :authenticate_user!

    def wxwork
      wechat_oauth2 do |user_name|
        raise Exception.new('获取微信用户名失败')

        Current.user = User.find_by wecom_id: user_name
        Current.user = User.find_by email: "#{user_name}@thape.com.cn" if Current.user.blank?

        raise Exception.new('获取用户信息失败') unless Current.user.present?

        sign_in Current.user
      end
    end
  end
end
