# frozen_string_literal: true

module Api
  module My
    class MessagesController < ApplicationController
      def index
        @list = Notification.where(notifiable_type: 'cybros.user').where(notifiable_id: current_user.id).order(created_at: :desc)

        @total = @list.count

        page, page_size = pagination_params
        @list = @list.page(page).per(page_size)
      end

      def read
        raise Exception.new('ID不能为空') unless params[:id].presence.present?
        messages = Notification
          .where(notifiable_type: 'cybros.user')
          .where(notifiable_id: current_user.id)
          .where(read_at: nil)

        if params[:id] === 'all'
          messages.update_all(read_at: Time.now)
        else
          ids = params[:id].split(',')&.map { |id| id.to_i }
          messages.where(id: ids).update_all(read_at: Time.now)
        end

        render json: { message: '更新成功' }
      end

      def destroy
        raise Exception.new('ID不能为空') unless params[:id].presence.present?
        messages = Notification
          .where(notifiable_type: 'cybros.user')
          .where(notifiable_id: current_user.id)

        if params[:id] === 'all'
          messages.delete_all
        else
          ids = params[:id].split(',')&.map { |id| id.to_i }
          messages.where(id: ids).delete_all
        end

        render json: { message: '删除成功' }
      end
    end
  end
end
