# frozen_string_literal: true

class User < ActiveRecord::Base
  establish_connection :user_info
  devise :database_authenticatable, :lockable, :validatable
end
