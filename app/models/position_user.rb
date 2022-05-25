# frozen_string_literal: true

class PositionUser < ActiveRecord::Base
  establish_connection :user_info

  belongs_to :user
  belongs_to :position

  delegate :name, to: :position, prefix: :position
end
