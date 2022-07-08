# frozen_string_literal: true

class CaseManufacturer < ApplicationRecord
  belongs_to :manufacturer
  belongs_to :project, class_name: 'Cases', foreign_key: :cases_id
end
