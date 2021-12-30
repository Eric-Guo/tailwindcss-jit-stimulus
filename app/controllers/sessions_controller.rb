# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
  end

  def destroy
    sign_out(current_user) if current_user.present?
    redirect_to root_path, alert: '成功登出'
  end
end
