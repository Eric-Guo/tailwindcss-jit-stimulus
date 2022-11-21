# frozen_string_literal: true

module Api
  module My
    class DemandsController < ApplicationController
      def index
        @list = Demand.includes(:replies, :material).where(clerk_code: current_user.clerk_code).order(created_at: :desc)
    
        @total = @list.count

        page, page_size = pagination_params
        @list = @list.page(page).per(page_size)
      end

      def show
        @demand = Demand.includes(:replies, :material).where(clerk_code: current_user.clerk_code).find(params[:id])
      end
    end
  end
end
