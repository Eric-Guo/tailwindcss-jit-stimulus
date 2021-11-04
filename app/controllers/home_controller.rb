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

    recently_project = Cases.order(created_at: :desc).first
    @recently_projects = if recently_project.present?
      Cases.order(created_at: :desc).where("", recently_project.created_at.strftime("%Y%m%d"))
    else
      Cases.none
    end

    @latest_news = News.order(updated_at: :desc).limit(4)

    @projects = Cases.order(created_at: :desc).limit(8)
  end
end
