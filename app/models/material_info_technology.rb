# frozen_string_literal: true

class MaterialInfoTechnology < ApplicationRecord
  self.table_name = 'material_info_technology'
  
  belongs_to :material_info
  belongs_to :technology, foreign_key: :technology_id
end
