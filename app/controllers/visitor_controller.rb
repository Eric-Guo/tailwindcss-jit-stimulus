# frozen_string_literal: true

class VisitorController < ApplicationController
  skip_before_action :set_tree_materials
  skip_before_action :set_sidebar_nav
  skip_before_action :set_footer_info

  def login
    visitor = Visitor.where(enabled: true).where('expired_at > ?', Time.now).find_by(code: params[:code])
    if visitor
      sign_in visitor
      redirect_to root_path
    else
      render html: "<h1>邀请链接已失效，<a href=\"/\">返回首页</a></h1>".html_safe
    end
  end

  def logout
    sign_out(current_visitor) if current_visitor.present?
    redirect_to root_path
  end
end
