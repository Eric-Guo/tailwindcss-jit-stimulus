# frozen_string_literal: true

class CaseRelevantDocument < ApplicationRecord
  default_scope { where(deleted_at: nil) }
end
