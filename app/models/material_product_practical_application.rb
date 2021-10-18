# frozen_string_literal: true

class MaterialProductPracticalApplication < ApplicationRecord
  belongs_to :material_product
  belongs_to :practical_application, foreign_key: :practical_applications_id
end
