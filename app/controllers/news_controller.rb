# frozen_string_literal: true

class NewsController < ApplicationController
  def index
    @panel_name = params[:pn].presence
    @q = ActiveRecord::Base::sanitize_sql(params[:q])

    @material_types = Material.where(level: 1, display: 1, deleted_at: nil).order(id: :asc)
    mat_ids = (params[:ms].presence || []).reject(&:blank?)
    @selected_mats = if mat_ids.present?
      Material.where(id: mat_ids)
    else
      Material.none
    end
    @selected_mat_parent_id = @selected_mats.collect(&:parent_id).first || 1

    @all_materials = Material.where(parent_id: @selected_mat_parent_id, display: 1, deleted_at: nil).order(id: :asc)
    @selected_all_materials = @all_materials.pluck(:id) == mat_ids.collect(&:to_i)
    @selected_none_materials = (@all_materials.pluck(:id) & mat_ids.collect(&:to_i)).blank?

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

    news_with_materials = if mat_ids.present?
      news_with_query.where(material_id: mat_ids.append(@selected_mat_parent_id))
    else
      news_with_query
    end

    @news = news_with_materials.limit(40)
  end
end
