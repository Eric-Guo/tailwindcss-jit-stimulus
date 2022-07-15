# frozen_string_literal: true

class CaseRecordRelevantDocument < ApplicationRecord
  belongs_to :project, class_name: 'CaseDelegateRecord', foreign_key: :case_delegate_record_id
  belongs_to :document, class_name: 'CaseRelevantDocument', foreign_key: :case_relevant_document_id
end
