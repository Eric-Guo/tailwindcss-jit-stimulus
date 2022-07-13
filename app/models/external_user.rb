# frozen_string_literal: true

class ExternalUser < ActiveRecord::Base
  belongs_to :manufacturer_record
end
