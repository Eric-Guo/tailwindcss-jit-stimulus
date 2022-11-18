# frozen_string_literal: true

module Api
  module My
    class ProjectsController < ApplicationController
      def index
        @list = CaseDelegate.joins(:record)
    
        # 如果存在部门10级及以上的职位，则获取该部门下所有的案例信息，否则只获取被委派的案例
        lv10_positions = current_user.positions.where('post_level >= 10')
        if lv10_positions.present?
          @list = @list.where('delegate_user_id = ? OR department_id IN (?)', current_user.id, lv10_positions.pluck(:department_id))
        else
          @list = @list.where(delegate_user_id: current_user.id)
        end
    
        # 关键词
        title = params[:title].presence&.strip
        @list = @list.where("`case_delegate_records`.project_name LIKE ?", "%#{title}%") if title.present?
    
        # 状态
        status = params[:status].presence&.strip
        if status.present?
          s = CaseDelegate.web_status_hash[status.to_sym]
          @list = @list.where(status: s[:names]) if status.present? if s.present?
        end
    
        @total = @list.count
        
        page, page_size = pagination_params
        @list = @list.page(page).per(page_size)
      end
    end
  end
end
