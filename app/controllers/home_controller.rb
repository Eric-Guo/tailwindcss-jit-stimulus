# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @total = {
      material: Material.count,
      project: Cases.count,
      manufacturer: Manufacturer.count,
    }

    recently_material = Material.where('level = ?', 3).order(created_at: :desc).first
    @recently_materials = if recently_material.present?
      Material.where('level = ?', 3).order(created_at: :desc).where("date_format(created_at, '%Y%m%d') = ?", recently_material.created_at.strftime('%Y%m%d'))
    else
      Material.none
    end
    @total[:recently_materials] = @recently_materials.count
    @recently_materials = @recently_materials.limit(16)

    recently_project = Cases.order(created_at: :desc).first
    @recently_projects = if recently_project.present?
      Cases.order(created_at: :desc).where("", recently_project.created_at.strftime("%Y%m%d"))
    else
      Cases.none
    end
    @total[:recently_project] = @recently_projects.count
    @recently_projects = @recently_projects.limit(10)
    
    @latest_news = News.order(updated_at: :desc).limit(4)

    @projects = Cases.order(top_at: :desc).limit(8)

    @material_cates = [
      { title: '石材', subtitle: 'Stone', cover: 'mat_nav_g1.jpg' },
      { title: '玻璃', subtitle: 'Glass', cover: 'mat_nav_g2.jpg' },
      { title: '陶瓷', subtitle: 'Ceramic', cover: 'mat_nav_g3.jpg' },
      { title: '混凝土/水泥', subtitle: 'Concrete/Cement', cover: 'mat_nav_g4.jpg' },
      { title: '木材', subtitle: 'Wood', cover: 'mat_nav_g5.jpg' },
      { title: '金属', subtitle: 'Mental', cover: 'mat_nav_g6.jpg' },
      { title: '涂料', subtitle: 'Paint', cover: 'mat_nav_g7.jpg' },
      { title: '高分子材料', subtitle: 'Plastic', cover: 'mat_nav_g8.jpg' },
      { title: '生态', subtitle: 'Ecology', cover: 'mat_nav_g9.jpg' },
      { title: '新材料', subtitle: 'New Materials', cover: 'mat_nav_g10.jpg' },
    ]

    @manufacturer_cates = Material.where(level: 1)
  end
end
