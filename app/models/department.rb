# frozen_string_literal: true

class Department < ActiveRecord::Base
  establish_connection :user_info

  has_many :department_users
  has_many :users, through: :department_users
end
