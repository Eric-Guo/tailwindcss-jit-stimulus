# frozen_string_literal: true

module PersonalCenter
  class HelpersController < ApplicationController
    def index
      @pdf_path = 'uploads/file/f08947cbf4f7e2a688ca1ca7522b5619_20220728182007.pdf';
      @img_path = 'uploads/file/00e4d0a485f45450ab0e217145a1b63a_20220728180707.jpg';
    end
  end
end
