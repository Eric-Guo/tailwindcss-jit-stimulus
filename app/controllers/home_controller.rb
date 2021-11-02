# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @total = {
      material: Material.count,
      project: Cases.count,
      manufacturer: Manufacturer.count,
    }

    @recently_materials = Material.where('level = ?', 3).order(created_at: :desc).limit(16)
    
    @latest_news = News.order(updated_at: :desc).limit(4)
  end
end
