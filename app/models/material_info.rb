# frozen_string_literal: true

class MaterialInfo < ApplicationRecord
  self.table_name = 'material_infos'

  belongs_to :material
  belongs_to :color_system
end
