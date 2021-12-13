# frozen_string_literal: true

class Cases < ApplicationRecord
  include ApplicationHelper

  self.table_name = 'cases'

  has_many :case_materials, -> { where(type_id: 2) }, class_name: 'CasesMaterial', foreign_key: :case_id
  has_many :case_samples, -> { where(type_id: 1) }, class_name: 'CasesMaterial', foreign_key: :case_id
  has_many :materials, through: :case_materials
  has_many :samples, through: :case_samples

  default_scope { where(deleted_at: nil).where(display: 1) }

  def project_name_and_location
    [self.project_name, self.project_location.gsub('上海市','')].select { |str| str.present? }.join('/')
  end

  def material_tags
    self.materials.limit(3).pluck(:name)
  end

  def banners
    arr = self.live_photos.is_a?(String) ? JSON.parse(self.live_photos) : self.live_photos;
    if arr.present? && arr.is_a?(Array)
      arr
    else
      []
    end
  end

  def self.project_locations
    where.not(project_location: nil)
    where.not(project_location: '')
    .order('project_location ASC')
    .select(:project_location)
    .distinct
    .pluck(:project_location)
  end

  # 立面控制手册
  def facade
    arr = self.ecm_files.is_a?(String) ? JSON.parse(self.ecm_files) : self.ecm_files;
    if self.is_th && arr.present? && arr.is_a?(Array)
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

  # 相关文件
  def related_files
    arr = self.documents.is_a?(String) ? JSON.parse(self.documents) : self.documents;
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
end
