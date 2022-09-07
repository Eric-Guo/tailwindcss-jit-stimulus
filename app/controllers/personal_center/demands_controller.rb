# frozen_string_literal: true

module PersonalCenter
  class DemandsController < ApplicationController
    before_action do
      @page = params[:page].to_i > 0 ? params[:page].to_i : 1
    end

    def index
      @page_size_options = [10, 20, 40, 80, 160]
      @page_size = params[:page_size].to_i > 0 ? params[:page_size].to_i : @page_size_options[0]

      @list = Demand
        .includes(:replies, :material)
        .where(clerk_code: current_user.clerk_code)
        .order(created_at: :desc)

      @total = @list.count
      @list = @list.page(@page).per(@page_size)
    end

    def show
      @demand = Demand.includes(:replies, :material).where(clerk_code: current_user.clerk_code).find(params[:id])
    end
  end
end
