# frozen_string_literal: true

class DemandReply < ApplicationRecord
  self.table_name = 'demand_replies'

  belongs_to :demand, class_name: 'Demand', foreign_key: :demand_id
end
