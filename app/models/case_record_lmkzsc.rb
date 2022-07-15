# frozen_string_literal: true

class CaseRecordLmkzsc < ApplicationRecord
  belongs_to :project, class_name: 'CaseDelegateRecord', foreign_key: :case_delegate_record_id
  belongs_to :lmkzsc
end
