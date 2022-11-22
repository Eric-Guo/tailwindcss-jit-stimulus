# frozen_string_literal: true

module Api
  module My
    class FeedbacksController < ApplicationController
      def index
        @list = ManufacturerFeedback
          .includes(:replies, :question_types, :manufacturer)
          .where(user_id: current_user.id)
          .order(created_at: :desc)

        @total = @list.count

        page, page_size = pagination_params
        @list = @list.page(@page).per(@page_size)
      end

      def show
        @feedback = ManufacturerFeedback.where(user_id: current_user.id).find(params[:id])
      end
    end
  end
end
