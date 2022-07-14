# frozen_string_literal: true

class ExternalUser < ActiveRecord::Base
  belongs_to :manufacturer_record
  has_many :external_cases, class_name: 'ExternalCases'
  has_many :cases, through: :external_cases, source: :case_delegate_record
end
