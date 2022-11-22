# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    skip_before_action :authenticate_user!

    def me
      unless user_signed_in?
        render json: nil
      end
    end

    def helpers
      @pdf_path = 'uploads/file/f08947cbf4f7e2a688ca1ca7522b5619_20220728182007.pdf';
      @img_path = 'uploads/file/00e4d0a485f45450ab0e217145a1b63a_20220728180707.jpg';
    end

    def wxwork_login
      wechat_oauth2 do |user_name|
        raise Exception.new('获取微信用户名失败')

        Current.user = User.find_by wecom_id: user_name
        Current.user = User.find_by email: "#{user_name}@thape.com.cn" if Current.user.blank?

        raise Exception.new('获取用户信息失败') unless Current.user.present?

        sign_in Current.user

        render json: { message: '登录成功' }
      end
    end
  end
end
