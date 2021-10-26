# frozen_string_literal: true

class SearchesController < ApplicationController
  before_action :set_q_params
  before_action :set_data_and_count_hash

  def material
  end

  def project
  end

  def manufacturer
  end

  def news
  end

  private

    def set_q_params
      @q = params[:q]
    end

    def set_data_and_count_hash
      @materials = if @q.present?
        Material.left_joins(:samples)
          .where('materials.name LIKE ? OR sample.genus LIKE ?', "%#{@q}%", "%#{@q}%")
      else
        Material.none
      end

      @cases = if @q.present?
        Cases.where('project_name LIKE ?', "%#{@q}%")
      else
        Cases.none
      end

      @manufacturers = if @q.present?
        Manufacturer.where('name LIKE ?', "%#{@q}%")
      else
        Manufacturer.none
      end

      @news = if @q.present?
        News.where('title LIKE ?', "%#{@q}%").or(News.where('subtitle LIKE ?', "%#{@q}%"))
      else
        News.none
      end

      @count_hash = {}
      @count_hash[:material] = @materials.count
      @count_hash[:project] = @cases.count
      @count_hash[:manufacturer] = @manufacturers.count
      @count_hash[:news] = @news.count
    end
end
