# frozen_string_literal: true

class CasesMaterial < ApplicationRecord
  self.table_name = 'cases_material'
  belongs_to :case, class_name: 'Cases'
  belongs_to :material
  belongs_to :sample

  default_scope { where(deleted_at: nil).where.not(case_id: nil) }
end
