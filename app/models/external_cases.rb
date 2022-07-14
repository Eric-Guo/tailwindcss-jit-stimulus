# frozen_string_literal: true

class ExternalCases < ActiveRecord::Base
  self.table_name = 'external_cases'
  
  belongs_to :project, class_name: 'Cases', foreign_key: :case_id
  belongs_to :external_user
  belongs_to :case_delegate_record
end
