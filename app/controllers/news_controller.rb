# frozen_string_literal: true

class NewsController < ApplicationController
  before_action :authenticate_user!
  before_action do
    @page = params[:page].to_i > 0 ? params[:page].to_i : 1
    @page_size = params[:page_size].to_i > 0 ? params[:page_size].to_i : 9
  end

  def index
    @panel_name = params[:pn].presence
    @q = ActiveRecord::Base::sanitize_sql(params[:q]&.strip)

    @material_types = Material.where(level: 1, display: 1, deleted_at: nil).order(id: :asc)
    @selected_material_type_ids = (params[:ms].presence || []).reject(&:blank?)
    @selected_mats = if @selected_material_type_ids.present?
      Material.where(id: @selected_material_type_ids)
    else
      Material.none
    end

    news_with_query = if @q.present?
      mat_q_ids = q_return_mat_ids(@q)
      if mat_q_ids.present?
        News.where(material_id: mat_q_ids)
      else
        News.where('title LIKE ? OR subtitle LIKE ? OR mold_name LIKE ?', "%#{@q}%", "%#{@q}%", "%#{@q}%")
      end
    else
      News.all
    end

    news_with_materials = if @selected_material_type_ids.present?
      news_with_query.joins(:news_materials).where(news_materials: { material_id: @selected_material_type_ids })
    else
      news_with_query
    end

    @news = news_with_materials.includes(:materials).order(published_at: :desc)
    @total = @news.count
    @news = @news.page(@page).per(@page_size)
  end
end
