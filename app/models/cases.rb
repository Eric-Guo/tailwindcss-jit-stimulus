# frozen_string_literal: true

class Cases < ApplicationRecord
  self.table_name = 'cases'
  has_many :case_materials, class_name: 'CasesMaterial'

  default_scope { where(deleted_at: nil).where(display: 1) }

  def material
    if level == 3
      material_product.color_system
    elsif level == 2
      material_info.color_system.description
    end
  end

  def project_name_and_location
    [self.project_name, self.project_location.gsub('上海市','')].select { |str| str.present? }.join('/')
  end
end
