# frozen_string_literal: true

class Visitor < ActiveRecord::Base
  devise :database_authenticatable

  attr_accessor :encrypted_password

  default_scope { where(deleted_at: nil) }

  def self.user_auth?(current_user)
    current_user.super_staff? || current_user.main_position_level >= 9
  end

  def effective?
    (self.enabled && self.expired_at && self.expired_at > Time.now).present?
  end
end
