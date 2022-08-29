# frozen_string_literal: true

class ManufacturerFeedbackQuestionType < ApplicationRecord
  self.table_name = 'manufacturer_feedback_question_type'
  
  belongs_to :manufacturer_feedback
  belongs_to :question_type
end
