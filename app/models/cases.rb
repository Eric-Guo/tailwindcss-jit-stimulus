# frozen_string_literal: true

class Cases < ApplicationRecord
  self.table_name = 'cases'

  has_many :case_materials, -> { where(type_id: 2) }, class_name: 'CasesMaterial', foreign_key: :case_id
  has_many :case_samples, -> { where(type_id: 1) }, class_name: 'CasesMaterial', foreign_key: :case_id
  has_many :materials, through: :case_materials

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

  def material_tags
    self.materials.limit(3).pluck(:name)
  end
end
