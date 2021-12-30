# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  def new
    super
  end

  def destroy
    sign_out(current_user) if current_user.present?
    redirect_to root_path, alert: '成功登出'
  end
end
