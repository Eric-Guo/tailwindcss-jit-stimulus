# frozen_string_literal: true

class MaterialInfo < ApplicationRecord
  belongs_to :material
  belongs_to :color_system

  default_scope { where(deleted_at: nil) }

  def construction
    if practice_details.present?
      if practice_details.is_a?(Array)
        practice_details
      else
        data = JSON.parse(practice_details)
        data.is_a?(Array) ? data : []
      end
    else
      []
    end.map { |item| item.with_indifferent_access }
  end
end
