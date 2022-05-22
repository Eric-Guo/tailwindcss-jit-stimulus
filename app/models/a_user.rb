# frozen_string_literal: true

class AUser < ActiveRecord::Base
  self.table_name = 'users'
  
  default_scope { where(deleted_at: nil) }
end
