# frozen_string_literal: true

class PersonalCentersController < ApplicationController
  before_action :authenticate_user!
  before_action :get_a_user
  before_action :get_no_read_message_count
  
  def projects
    title = params[:title].presence&.strip
    status = params[:status].presence&.strip
    @list = CaseDelegate.joins(:record).where(user_id: @a_user.id)
    @list = @list.where("`case_delegate_records`.project_name LIKE ?", "%#{title}%") if title.present?
    @list = @list.where(status: params[:status]) if status.present?
  end

  def messages
    @list = Notification
      # .where(notifiable_id: current_user.id)
      .order(created_at: :desc)
      .all
  end

  def set_message_read
    message = Notification
      # .where(notifiable_id: current_user.id)
      .find(params[:id])

    if message.read_at.blank?
      message.read_at = Time.now
      message.save
    end

    redirect_to messages_personal_center_path
  end

  def rm_message
    message = Notification
      # .where(notifiable_id: current_user.id)
      .find(params[:id])
    message.deleted_at = Time.now
    message.save

    redirect_to messages_personal_center_path
  end


  def demands
    @list = Demand
      .includes(:replies, :material)
      # .where(clerk_code: current_user.clerk_code)
      .all
    puts @list
  end

  def suppliers
  end

  private
    def get_a_user
      @a_user = AUser.find_by(clerk_code: current_user.clerk_code)
    end

    def get_no_read_message_count
      @no_read_message_count = Notification
        # .where(notifiable_id: current_user.id)
        .where('read_at IS NULL')
        .count
    end
end
