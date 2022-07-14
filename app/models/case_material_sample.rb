# frozen_string_literal: true

class CaseMaterialSample < ApplicationRecord
  belongs_to :case_material, foreign_key: :cases_material_id
  belongs_to :sample
end
