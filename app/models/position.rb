# frozen_string_literal: true

class Position < ActiveRecord::Base
  establish_connection :user_info

  belongs_to :department, optional: true
end
