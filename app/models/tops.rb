# frozen_string_literal: true

class Tops < ApplicationRecord
  self.table_name = 'tops'
  default_scope { where(deleted_at: nil) }
end
