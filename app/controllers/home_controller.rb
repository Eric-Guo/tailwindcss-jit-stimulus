# frozen_string_literal: true

class HomeController < ApplicationController
  before_action only: [:index], if: -> { request.variant.include?(:phone) } do
    redirect_to '/m/'
  end

  def index
    @total = {
      material: Material.count + Sample.joins(:material).count,
      project: Cases.count,
      manufacturer: Manufacturer.count,
    }

    # 新增材料数据计算
    recently_material_created_time = Material.where('level = ?', 3).order(created_at: :desc).first&.created_at&.strftime('%Y%m%d')
    recently_ms_created_time = recently_material_created_time
    recently_sample_created_time = Sample.joins(:material).order(created_at: :desc).first&.created_at&.strftime('%Y%m%d')
    recently_ms_created_time = recently_sample_created_time if recently_sample_created_time.present? && recently_sample_created_time > recently_ms_created_time

    @recently_materials = if recently_ms_created_time.present?
      Material.where('level = ?', 3).where("date_format(created_at, '%Y%m%d') = ?", recently_ms_created_time)
    else
      Material.none
    end
    @recently_samples = if recently_ms_created_time.present?
      Sample.joins(:material).where("date_format(sample.created_at, '%Y%m%d') = ?", recently_ms_created_time)
    else
      Sample.none
    end
    @total[:recently_materials] = @recently_materials.count + @recently_samples.count

    @recently_materials = Tops.where('top_model = ?', 'home_new_material').where('material_id > ?', 0).order(top_sort: :desc)

    recently_project = Cases.order(created_at: :desc).first
    @recently_projects = if recently_project.present?
      Cases.order(created_at: :desc).where("", recently_project.created_at.strftime("%Y%m%d"))
    else
      Cases.none
    end
    @total[:recently_project] = @recently_projects.count
    @recently_projects = Tops.where('top_model = ?', 'home_new_cases').where('case_id > ?', 0).order(top_sort: :desc)

    @latest_news = News.order(top: :desc).order(published_at: :desc).limit(4)

    @projects = Tops.where('top_model = ?', 'home_top_cases').where('case_id > ?', 0).order(top_sort: :desc)

    @material_cates = [
      { no: 'A', cover: 'mat_nav_g1.jpg' },
      { no: 'B', cover: 'mat_nav_g6.jpg' },
      { no: 'C', cover: 'mat_nav_g3.jpg' },
      { no: 'D', cover: 'mat_nav_g7.jpg' },
      { no: 'E', cover: 'mat_nav_g2.jpg' },
      { no: 'F', cover: 'mat_nav_g4.jpg' },
      { no: 'G', cover: 'mat_nav_g5.jpg' },
      { no: 'H', cover: 'mat_nav_g8.jpg' },
      { no: 'Y', cover: 'mat_nav_g9.jpg' },
      { no: 'Z', cover: 'mat_nav_g10.jpg' },
    ]
    materials = Material.where(no: @material_cates.pluck(:no)).where(level: 1).order(no: :asc).all
    @material_cates = @material_cates.each do |cate|
      material = materials.detect { |m| m.no == cate[:no] }
      cate[:mat] = material
      cate[:title] = material&.name
      cate[:subtitle] = material&.en_name
    end

    @manufacturer_cates = Material.where(level: 1).order(no: :asc).includes(:children_materials).map do |manufacturer_cate|
      material_ids = Material.where('id = :id OR parent_id = :id OR grandpa_id = :id', id: manufacturer_cate.id).pluck(:id)
      manufacturers = Manufacturer.joins(:material_manufacturers).where(material_manufacturers: { material_id: material_ids }).order(top_at: :desc).limit(2).distinct
      {
        name: manufacturer_cate.name,
        manufacturers: manufacturers.map do |manufacturer|
          {
            id: manufacturer.id,
            name: manufacturer.name,
            logo: manufacturer.logo,
          }
        end,
        children: manufacturer_cate.children_materials,
      }
    end
  end
end
