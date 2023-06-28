# frozen_string_literal: true

module Api
  class UsersController < ApplicationController
    skip_before_action :authenticate_any!

    def me
      if user_signed_in?
      elsif visitor_signed_in?
        render json: {
          type: 'visitor',
          id: current_visitor.id,
          code: current_visitor.code,
          expired_at: current_visitor.expired_at.strftime('%Y-%m-%d %H:%M:%S'),
        }
      else
        render json: nil
      end
    end

    def helpers
      @pdf_path = 'uploads/file/f08947cbf4f7e2a688ca1ca7522b5619_20220728182007.pdf';
      @img_path = 'uploads/file/00e4d0a485f45450ab0e217145a1b63a_20220728180707.jpg';
    end
  end
end
