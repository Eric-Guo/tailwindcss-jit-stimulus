# frozen_string_literal: true

class CaseManyDesignPhoto < ApplicationRecord
  belongs_to :project, class_name: 'Cases', foreign_key: :cases_id
  belongs_to :design_photo, class_name: 'CaseDesignPhoto', foreign_key: :case_design_photo_id
end
