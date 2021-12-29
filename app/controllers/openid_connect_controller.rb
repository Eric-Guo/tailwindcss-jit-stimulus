# frozen_string_literal: true

class OpenidConnectController < ApplicationController
  def callback
    @omniaut_auth = request.env['omniauth.auth']
    # Rails.logger.debug "omniaut_auth: " + JSON.pretty_generate(@omniaut_auth)
    user = User.find_or_create_by!(email: @omniaut_auth.dig(:info, :email)) do |u|
      u.confirmed_at = Time.current
      random_password = SecureRandom.hex(4) # like "301bccce"
      u.password = random_password
      u.password_confirmation = random_password
    end
    user.update(confirmed_at: Time.current) if user.confirmed_at.blank?
    main_position_title = @omniaut_auth.dig(:extra, :raw_info, :main_position, :name)
    clerk_code = @omniaut_auth.dig(:extra, :raw_info, :clerk_code)
    chinese_name = @omniaut_auth.dig(:extra, :raw_info, :chinese_name)
    desk_phone = @omniaut_auth.dig(:extra, :raw_info, :desk_phone)
    job_level = @omniaut_auth.dig(:extra, :raw_info, :job_level)
    user.update(position_title: main_position_title, clerk_code: clerk_code,
      chinese_name: chinese_name, job_level: job_level, desk_phone: desk_phone)

    original_url = request.env['omniauth.origin']
    sign_in user
    if !original_url.nil? && original_url != 'https://sso.thape.com.cn/'
      redirect_to original_url
    else
      redirect_to root_path
    end
  end
end
