# frozen_string_literal: true

class OpenidConnectController < ApplicationController
  def callback
    @omniaut_auth = request.env['omniauth.auth']
    # Rails.logger.debug "omniaut_auth: " + JSON.pretty_generate(@omniaut_auth)
    user = User.find_by!(email: @omniaut_auth.dig(:info, :email))
    original_url = request.env['omniauth.origin']
    sign_in user
    if !original_url.nil? && original_url != 'https://sso.thape.com.cn/'
      redirect_to original_url
    else
      redirect_to root_path
    end
  end
end
