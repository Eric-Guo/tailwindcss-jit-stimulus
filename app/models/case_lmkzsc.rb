# frozen_string_literal: true

class CaseLmkzsc < ApplicationRecord
  belongs_to :project, class_name: 'Cases', foreign_key: :cases_id
  belongs_to :lmkzsc
end
