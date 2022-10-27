# frozen_string_literal: true

class MaterialInfo < ApplicationRecord
  belongs_to :material
  belongs_to :color_system
  has_many :material_info_technology, class_name: 'MaterialInfoTechnology'
  has_many :technology, through: :material_info_technology, class_name: 'Technology'

  default_scope { where(deleted_at: nil) }

  def construction
    if practice_details.present?
      if practice_details.is_a?(Array)
        practice_details
      else
        data = JSON.parse(practice_details)
        data.is_a?(Array) ? data : []
      end
    else
      []
    end.map { |item| item.with_indifferent_access }
  end

  def technology_str
    technology.pluck(:description).join(' ')
  end

  def price_range
    "#{[low_price, high_price].uniq.join(' - ')} 元/㎡"
  end

  def related_files
    arr = source_file.is_a?(String) && source_file.present? ? JSON.parse(source_file) : source_file;
    if arr.present? && arr.is_a?(Array)
      arr.select { |item| item['url'].present? }.map do |item|
        file_tag = get_file_tag(item['url'])
        {
          tag_name: file_tag[:name],
          tag_icon: file_tag[:icon],
          name: item['name'],
          url: item['url'],
        }
      end
    else
      []
    end
  end

  def practical_applications_json
    arr = self.practical_applications.is_a?(String) && self.practical_applications.present? ? JSON.parse(self.practical_applications) : self.practical_applications
    if arr.present? && arr.is_a?(Array)
      arr.map { |item| item.with_indifferent_access }
    else
      []
    end
  end
end
