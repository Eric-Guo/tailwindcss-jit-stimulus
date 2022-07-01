# frozen_string_literal: true

class User < ActiveRecord::Base
  establish_connection :user_info
  devise :database_authenticatable

  has_many :department_users, dependent: :destroy
  has_many :departments, through: :department_users

  has_many :position_users, -> { order(main_position: :desc) }, dependent: :destroy
  has_many :positions, through: :position_users

  def main_position
    @_main_position ||= positions.where(position_users: { main_position: true }).first
  end
end
