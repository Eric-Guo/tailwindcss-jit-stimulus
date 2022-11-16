# frozen_string_literal: true

module Api
  class NewsController < ApplicationController
    def index
      @list = News.order(published_at: :desc)

      # 关键词
      keywords = ActiveRecord::Base::sanitize_sql(params[:keywords]&.strip)
      if keywords.present?
        q_mat_ids = MaterialAndSample.where(sample_id: nil).where('material_name LIKE :q_like OR parent_material_name LIKE :q_like OR grandpa_material_name LIKE :q_like', q_like: "%#{keywords}%").pluck(:material_id)
        news_ids = NewsMaterial.where(material_id: q_mat_ids).pluck(:news_id)
        @list = @list.where('title LIKE :q_like OR subtitle LIKE :q_like OR mold_name LIKE :q_like OR id IN (:news_ids)', q_like: "%#{keywords}%", news_ids: news_ids)
      end

      mat1_id = params[:mat1_id].presence&.strip
      mat_ids = params[:mat_ids].is_a?(Array) ? params[:mat_ids] : (params[:mat_ids].presence&.split(',') || [])
      mat_ids = mat_ids.reject(&:blank?).collect(&:to_i)

      if mat_ids.blank? && mat1_id.present?
        mat_ids = Material.where(level: 2).where(parent_id: mat1_id).pluck(:id)
        mat_ids << mat1_id.to_i
      end

      if mat1_id.present?
        news_ids = NewsMaterial.where(material_id: mat_ids).pluck(:news_id)
        @list = @list.where('id IN (?)', news_ids)
      end

      @total = @list.count

      page, page_size = pagination_params
      @list = @list.page(page).per(page_size)
    end
  end
end
