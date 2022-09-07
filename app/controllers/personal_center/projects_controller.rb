# frozen_string_literal: true

module PersonalCenter
  class ProjectsController < ApplicationController
    before_action do
      @page = params[:page].to_i > 0 ? params[:page].to_i : 1
    end

    def index
      @page_size_options = [8, 12, 20, 36, 68]
      @page_size = params[:page_size].to_i > 0 ? params[:page_size].to_i : @page_size_options[0]
  
      title = params[:title].presence&.strip
      status = params[:status].presence&.strip
      lv10_positions = current_user.positions.where('post_level >= 10')
  
      @list = CaseDelegate.joins(:record)
      # 如果存在部门10级及以上的职位，则获取该部门下所有的案例信息，否则只获取被委派的案例
      if lv10_positions.present?
        @list = @list.where('delegate_user_id = ? OR department_id IN (?)', current_user.id, lv10_positions.pluck(:department_id))
      else
        @list = @list.where(delegate_user_id: current_user.id)
      end
      @list = @list.where("`case_delegate_records`.project_name LIKE ?", "%#{title}%") if title.present?
      if status.present?
        s = CaseDelegate.web_status_hash[status.to_sym]
        @list = @list.where(status: s[:names]) if status.present? if s.present?
      end
  
      @total = @list.count
      @list = @list.page(@page).per(@page_size)
    end
  end
end
