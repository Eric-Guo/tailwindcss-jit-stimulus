# frozen_string_literal: true

class Sample < ApplicationRecord
  self.table_name = 'sample'

  belongs_to :material, foreign_key: :obj_id, class_name: 'Material'
  belongs_to :surface_effect
  belongs_to :manufacturer
end
