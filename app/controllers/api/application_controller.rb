# frozen_string_literal: true

module Api
  class ApplicationController < ActionController::API
    include ActionController::Helpers
    helper ApplicationHelper
  end
end
