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
      @material_samples = if @q.present?
        MaterialAndSample.where('material_level IN (2,3)')
          .where('material_name LIKE :keywords OR parent_material_name LIKE :keywords OR grandpa_material_name LIKE :keywords', keywords: "%#{@q}%")
      else
        MaterialAndSample.none
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
      @count_hash[:material] = @material_samples.count
      @count_hash[:project] = @cases.count
      @count_hash[:manufacturer] = @manufacturers.count
      @count_hash[:news] = @news.count
    end
end
