# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    before_action :authenticate_user!
    
    def me
    end
  end
end
