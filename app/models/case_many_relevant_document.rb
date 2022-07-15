# frozen_string_literal: true

class CaseManyRelevantDocument < ApplicationRecord
  belongs_to :project, class_name: 'Cases', foreign_key: :cases_id
  belongs_to :documents, class_name: 'CaseRelevantDocument', foreign_key: :case_relevant_document_id
end
