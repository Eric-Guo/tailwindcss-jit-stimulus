# frozen_string_literal: true

module Api
  module My
    class ManufacturersController < ApplicationController
      def index
        @list = ManufacturerRecommend.where(user_id: current_user.id).order(created_at: :desc).order(id: :asc)
    
        @total = @list.count
    
        page, page_size = pagination_params
        @list = @list.page(page).per(page_size)
      end
    
      def show
        @manufacturer = ManufacturerRecommend.find(params[:id])
      end
    end
  end
end
