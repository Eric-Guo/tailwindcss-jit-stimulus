# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    skip_before_action :authenticate_user!, only: [:me]

    def me
      unless user_signed_in?
        render json: nil
      end
    end
  end
end
