# frozen_string_literal: true

class Tops < ApplicationRecord
  self.table_name = 'tops'
  belongs_to :home_top_case, class_name: 'Cases', foreign_key: :case_id
  default_scope { where(deleted_at: nil) }
end
