# frozen_string_literal: true

module Api
  module My
    class StatisticsController < ApplicationController
      before_action :authenticate_user!

      def index
        @message_count = Notification.where(notifiable_type: 'cybros.user').where(notifiable_id: current_user.id).where('read_at IS NULL').count
      end
    end
  end
end
