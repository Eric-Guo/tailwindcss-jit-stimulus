# frozen_string_literal: true

class Manufacturer < ApplicationRecord
  has_many :samples

  has_many :material_manufacturers
  has_many :materials, through: :material_manufacturers

  has_many :manufacturer_areas
  has_many :areas, through: :manufacturer_areas

  has_many :case_manufacturers, foreign_key: :manufacturer_id
  has_many :cases, through: :case_manufacturers, class_name: 'Cases', source: :project

  has_many :news

  has_many :contacts, class_name: 'ManufacturerContact'

  # 企业宣传册
  has_many :brochures, class_name: 'ManufacturerBrochure'

  default_scope { where(display: 1).where(deleted_at: nil).where(status: 'manufacturer_published') }

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

  # 服务区域
  def location
    @_location ||= areas.pluck(:title).join(',')
  end
  
  # 相关文件
  def brochure_files
    @_brochure_files ||= brochures.select { |item| item.path.present? }.map do |item|
      file_tag = get_file_tag(item.path)
      {
        id: item.id,
        tag_name: file_tag[:name],
        tag_icon: file_tag[:icon],
        name: item.title,
        url: item.path,
      }
    end
  end
end
