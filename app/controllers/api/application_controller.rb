# frozen_string_literal: true

module Api
  class ApplicationController < ActionController::API
    include ActionController::Helpers
    helper ApplicationHelper

    def pagination_params
      page = params[:page].to_i > 0 ? params[:page].to_i : 1
      page_size = params[:page_size].to_i > 0 ? params[:page_size].to_i : 10
      [page, page_size]
    end
  end
end
