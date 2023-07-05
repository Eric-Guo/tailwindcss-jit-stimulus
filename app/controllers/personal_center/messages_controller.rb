# frozen_string_literal: true

module PersonalCenter
  class MessagesController < ApplicationController
    before_action do
      @page = params[:page].to_i > 0 ? params[:page].to_i : 1
    end

    def index
      @page_size_options = [5, 10, 20, 30, 50]
      @page_size = params[:page_size].to_i > 0 ? params[:page_size].to_i : @page_size_options[0]

      @list = Notification
        .where(notifiable_type: 'cybros.user')
        .where(notifiable_id: current_user.id)
        .order(created_at: :desc)
      @total = @list.count
      @list = @list.page(@page).per(@page_size)
    end

    def update
      ids = params[:id]&.split(',')&.map { |id| id.to_i }
      raise StandardError.new('ID不能为空') unless ids.present?

      messages = Notification
        .where(notifiable_type: 'cybros.user')
        .where(notifiable_id: current_user.id)
        .where(read_at: nil)
        .where(id: ids)
        .all
      messages.each do |message|
        message.read_at = Time.now
        message.save
      end

      if request.headers['HTTP_REFERER'].present?
        redirect_to request.headers['HTTP_REFERER']
      else
        redirect_to personal_center_messages_path
      end
    end

    def remove
      ids = params[:id]&.split(',')&.map { |id| id.to_i }
      raise StandardError.new('ID不能为空') unless ids.present?

      messages = Notification
        .where(notifiable_type: 'cybros.user')
        .where(notifiable_id: current_user.id)
        .where(id: ids)
        .all
      messages.each do |message|
        message.deleted_at = Time.now
        message.save
      end
  
      redirect_to personal_center_messages_path
    end
  end
end
