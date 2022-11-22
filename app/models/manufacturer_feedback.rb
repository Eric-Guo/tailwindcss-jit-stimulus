# frozen_string_literal: true

class ManufacturerFeedback < ApplicationRecord
  belongs_to :manufacturer
  belongs_to :user

  has_many :manufacturer_feedback_question_types
  has_many :question_types, through: :manufacturer_feedback_question_types

  has_many :replies, class_name: 'ManufacturerFeedbackReply'

  default_scope { where(deleted_at: nil) }

  def references_json
    return [] unless references.present?
    JSON.parse(references)&.map do |item|
      {
        name: item[:name],
        path: item[:path],
      }
    end || []
  end
end
