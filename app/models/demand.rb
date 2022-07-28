# frozen_string_literal: true

class Demand < ApplicationRecord
  self.table_name = 'demands'

  default_scope { where(deleted_at: nil) }

  has_many :replies, class_name: 'DemandReply', foreign_key: :demand_id

  belongs_to :material, class_name: 'Material', foreign_key: :material_id

  def cate_name
    case demand_type
    when 1
      '品类'
    when 2
      '样品'
    when 3
      '项目/案例'
    when 4
      '供应商'
    else
      '未知'
    end
  end

  def references_json
    if references.present?
      if references.is_a?(Array)
        references.map { |item| item.with_indifferent_access }
      else
        JSON.parse(references).map { |item| item.with_indifferent_access }
      end
    else
      []
    end
  end
end
