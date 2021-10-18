# frozen_string_literal: true

class PracticalApplication < ApplicationRecord
  has_many :material_product_practical_applications, primary_key: :practical_applications_id
  has_many :material_products, through: :material_product_practical_applications
  # default_scope { where(self.table_name + '.deleted_at is null') }
end

