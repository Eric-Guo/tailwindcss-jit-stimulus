# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @total = {
      material: Material.count + Sample.joins(:material).count,
      project: Cases.count,
      manufacturer: Manufacturer.count,
    }

    # 新增材料数据计算
    recently_material_created_time = Material.where('level = ?', 3).order(created_at: :desc).first&.created_at.strftime('%Y%m%d')
    recently_ms_created_time = recently_material_created_time
    recently_sample_created_time = Sample.joins(:material).order(created_at: :desc).first&.created_at.strftime('%Y%m%d')
    recently_ms_created_time = recently_sample_created_time if recently_sample_created_time > recently_ms_created_time
    puts recently_ms_created_time, recently_sample_created_time, recently_ms_created_time
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
      { title: '石材', cover: 'mat_nav_g1.jpg' },
      { title: '玻璃', cover: 'mat_nav_g2.jpg' },
      { title: '陶瓷', cover: 'mat_nav_g3.jpg' },
      { title: '混凝土/水泥', cover: 'mat_nav_g4.jpg' },
      { title: '木材', cover: 'mat_nav_g5.jpg' },
      { title: '金属', cover: 'mat_nav_g6.jpg' },
      { title: '涂料', cover: 'mat_nav_g7.jpg' },
      { title: '高分子材料', cover: 'mat_nav_g8.jpg' },
      { title: '生态', cover: 'mat_nav_g9.jpg' },
      { title: '新型', cover: 'mat_nav_g10.jpg' },
    ]
    materials = Material.where(name: @material_cates.pluck(:title)).where(level: 1).all
    @material_cates.each do |cate|
      material = materials.detect { |m| m.name == cate[:title] }
      cate[:mat] = material
      cate[:subtitle] = material&.en_name
    end

    @manufacturer_cates = Material.where(level: 1).includes(:children_materials).map do |manufacturer_cate|
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
