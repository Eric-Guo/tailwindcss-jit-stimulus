# frozen_string_literal: true

class ManufacturerRecord < ApplicationRecord
  has_many :material_manufacturer_records
  has_many :materials, through: :material_manufacturer_records
  has_many :manufacturer_record_areas
  has_many :areas, through: :manufacturer_record_areas
  has_many :contacts, class_name: "ManufacturerContact"
  has_one :external_user

  default_scope { where(deleted_at: nil) }

  def self.sort_by_logo(sort = :desc)
    order(Arel.sql("CASE WHEN logo IS NULL THEN 0 WHEN logo = '' THEN 1 ELSE 2 END #{sort}"))
  end

  def self.manufacturer_locations
    @manufacturer_locations ||= all.joins(:areas)
      .order('manufacturer_areas.area_id')
      .distinct
      .select('areas.title area_title', 'manufacturer_areas.area_id')
  end

  def offer_sample
    if self.is_allow == 1 || self.is_allow == true
      '是'
    elsif self.is_allow == 0 || self.is_allow == false
      '去电详询'
    else
      '否'
    end
  end

  def banners
    arr = self.performance_display.is_a?(String) ? JSON.parse(self.performance_display) : self.performance_display
    if arr.present? && arr.is_a?(Array)
      arr.map { |item| item.with_indifferent_access }
    else
      []
    end
  end

  # 主营材料
  def main_materials
    self.materials.pluck(:name).join(',')
  end

  # 是否与天华合作过
  def tho_co_str
    if self.is_tho_co == 1 || self.is_tho_co == true
      '是'
    else
      '—'
    end
  end

  def location
    @_location ||= areas.pluck(:title).join(',')
  end

  def website
    web_site
  end
end
