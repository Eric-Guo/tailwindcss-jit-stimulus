# frozen_string_literal: true

class DepartmentUser < ActiveRecord::Base
  establish_connection :user_info

  belongs_to :department
  belongs_to :user
end
