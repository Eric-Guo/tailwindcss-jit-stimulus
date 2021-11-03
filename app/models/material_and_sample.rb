# frozen_string_literal: true

class MaterialAndSample < ApplicationRecord
  self.table_name = 'material_and_sample'

  belongs_to :material, foreign_key: :material_id, class_name: 'Material'
  belongs_to :parent_material, foreign_key: :parent_material_id, class_name: 'Material', optional: true
  belongs_to :grandpa_material, foreign_key: :grandpa_material_id, class_name: 'Material', optional: true
  belongs_to :sample, foreign_key: :sample_id, class_name: 'Sample', optional: true


  def level_name
    case material_level
    when 2
      "#{parent_material_name}"
    when 3
      "#{grandpa_material_name}-#{parent_material_name}"
    else
      ''
    end
  end

end
