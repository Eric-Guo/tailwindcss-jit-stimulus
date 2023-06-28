# frozen_string_literal: true

class Visitor < ActiveRecord::Base
  devise :database_authenticatable

  attr_accessor :encrypted_password

  default_scope { where(deleted_at: nil) }

  def effective?
    (self.enabled && self.expired_at && self.expired_at > Time.now).present?
  end
end
