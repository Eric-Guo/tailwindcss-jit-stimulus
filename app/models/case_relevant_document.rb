# frozen_string_literal: true

class CaseRelevantDocument < ApplicationRecord
  belongs_to :case

  default_scope { where(deleted_at: nil) }
end
