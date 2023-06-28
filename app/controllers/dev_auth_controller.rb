# frozen_string_literal: true

class DevAuthController < ApplicationController
  skip_before_action :set_tree_materials
  skip_before_action :set_sidebar_nav
  skip_before_action :set_footer_info

  def login
    if Rails.env.development?
      sign_in User.where('clerk_code = ?', '019795').first unless user_signed_in?
      redirect_to root_path
    end
  end

  def logout
    sign_out(current_user) if current_user.present?
    redirect_to root_path
  end
end
