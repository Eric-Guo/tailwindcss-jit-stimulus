# frozen_string_literal: true

module PersonalCenter
  class ApplicationController < ApplicationController
    before_action if: -> { request.variant.include?(:phone) } do
      redirect_to '/m/user'
    end
    before_action :authenticate_user!
    before_action :get_no_read_message_count

    private
      def get_no_read_message_count
        @no_read_message_count = Notification
          .where(notifiable_id: current_user.id)
          .where('read_at IS NULL')
          .count
      end
  end
end
