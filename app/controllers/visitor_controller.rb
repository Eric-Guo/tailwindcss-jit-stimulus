# frozen_string_literal: true

class VisitorController < ApplicationController
  skip_before_action :set_tree_materials
  skip_before_action :set_sidebar_nav
  skip_before_action :set_footer_info

  def login
    visitor = Visitor.where(enabled: true).where('expired_at > ?', Time.now).find_by!(code: params[:code])
    sign_in visitor
    redirect_to root_path
  end

  def logout
    sign_out(current_visitor) if current_visitor.present?
    redirect_to root_path
  end
end
