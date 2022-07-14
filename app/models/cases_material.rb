# frozen_string_literal: true

class CasesMaterial < ApplicationRecord
  self.table_name = 'cases_material'
  belongs_to :case, class_name: 'Cases'
  belongs_to :material
  belongs_to :sample
  belongs_to :manufacturer

  has_many :case_material_samples
  has_many :samples, through: :case_material_samples

  default_scope { where(deleted_at: nil) }

  def material_color
    arr = []
    arr.push(material.color) if material.color.present?
    arr.push(color_code) if color_code.present?
    arr.join(';')
  end
end
