# frozen_string_literal: true

class PersonalCentersController < ApplicationController
  before_action :authenticate_user!
  before_action :get_no_read_message_count
  
  def projects
    title = params[:title].presence&.strip
    status = params[:status].presence&.strip
    lv10_positions = current_user.positions.where('post_level >= 10')
    @list = CaseDelegate.joins(:record)
    # 如果存在部门10级及以上的职位，则获取该部门下所有的案例信息，否则只获取被委派的案例
    if lv10_positions.present?
      @list = @list.where('delegate_user_id = ? OR department_id IN (?)', current_user.id, lv10_positions.pluck(:department_id))
    else
      @list = @list.where(delegate_user_id: current_user.id).group("id")
    end
    @list = @list.where("`case_delegate_records`.project_name LIKE ?", "%#{title}%") if title.present?
    if status.present?
      s = CaseDelegate.web_status_hash[status.to_sym]
      @list = @list.where(status: s[:names]) if status.present? if s.present?
    end

  end

  def messages
    @list = Notification
      .where(notifiable_type: 'cybros.user')
      .where(notifiable_id: current_user.id)
      .order(created_at: :desc)
      .all
  end

  def set_message_read
    message = Notification
      .where(notifiable_type: 'cybros.user')
      .where(notifiable_id: current_user.id)
      .find(params[:id])

    if message.read_at.blank?
      message.read_at = Time.now
      message.save
    end

    redirect_to messages_personal_center_path
  end

  def rm_message
    message = Notification
      .where(notifiable_type: 'cybros.user')
      .where(notifiable_id: current_user.id)
      .find(params[:id])
    message.deleted_at = Time.now
    message.save

    redirect_to messages_personal_center_path
  end


  def demands
    @list = Demand
      .includes(:replies, :material)
      .where(clerk_code: current_user.clerk_code)
      .all
    puts @list
  end

  def suppliers
  end

  private
    def get_no_read_message_count
      @no_read_message_count = Notification
        .where(notifiable_id: current_user.id)
        .where('read_at IS NULL')
        .count
    end
end
