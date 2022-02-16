# frozen_string_literal: true

class News < ApplicationRecord
  has_many :news_materials
  has_many :materials, through: :news_materials
  default_scope { where(deleted_at: nil).where(display: 1) }

  def cl_online?
    cl_online_id.present? && cl_online_id != 0 && cl_online_id != ''
  end
end
