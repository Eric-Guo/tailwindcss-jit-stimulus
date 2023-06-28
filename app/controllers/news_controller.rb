# frozen_string_literal: true

class NewsController < ApplicationController
  before_action only: [:index], if: -> { request.variant.include?(:phone) } do
    redirect_to '/m/news'
  end
  before_action :authenticate_any!
  before_action do
    @page = params[:page].to_i > 0 ? params[:page].to_i : 1
  end

  def index
    if turbo_frame_request?
      @page_size_options = [9, 12, 18, 30, 54]
      @page_size = params[:page_size].to_i > 0 ? params[:page_size].to_i : @page_size_options[0]

      @q = ActiveRecord::Base::sanitize_sql(params[:q]&.strip)
      @material_type_ids = (params[:ms].presence || []).reject(&:blank?)

      @news = News.order(published_at: :desc)

      if @q.present?
        q_mat_ids = MaterialAndSample.where(sample_id: nil).where('material_name LIKE :q_like OR parent_material_name LIKE :q_like OR grandpa_material_name LIKE :q_like', q_like: "%#{@q}%").pluck(:material_id)
        news_ids = NewsMaterial.where(material_id: q_mat_ids).pluck(:news_id)
        @news = @news.where('title LIKE :q_like OR subtitle LIKE :q_like OR mold_name LIKE :q_like OR id IN (:news_ids)', q_like: "%#{@q}%", news_ids: news_ids)
      end

      if @material_type_ids.present?
        news_ids = NewsMaterial.where(material_id: @material_type_ids).pluck(:news_id)
        @news = @news.where('id IN (?)', news_ids)
      end

      @total = @news.count
      @news = @news.page(@page).per(@page_size)

      render 'list'
    end
  end
end
