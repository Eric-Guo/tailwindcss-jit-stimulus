# frozen_string_literal: true

class CaseRelevantDocument < ApplicationRecord
  belongs_to :case, foreign_key: :case_id

  default_scope { where(deleted_at: nil) }
end
