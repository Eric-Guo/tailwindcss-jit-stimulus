# frozen_string_literal: true

class SearchesController < ApplicationController
  before_action :set_q_params
  before_action :set_data_and_count_hash

  def show
    if @q.present?
      if @count_hash[:material] > 0
        redirect_to material_search_path(q: @q)
      elsif @count_hash[:project] > 0
        redirect_to project_search_path(q: @q)
      elsif @count_hash[:manufacturer] > 0
        redirect_to manufacturer_search_path(q: @q)
      elsif @count_hash[:news] > 0
        redirect_to news_search_path(q: @q)
      else
        redirect_to material_search_path(q: @q)
      end      
    end
  end

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
      @q = ActiveRecord::Base::sanitize_sql(params[:q]&.strip)
    end

    def set_data_and_count_hash
      @material_samples = if @q.present?
        MaterialAndSample.where('material_level IN (2,3)')
          .where('material_name LIKE :keywords OR parent_material_name LIKE :keywords OR grandpa_material_name LIKE :keywords', keywords: "%#{@q}%")
      else
        MaterialAndSample.none
      end

      @cases = if @q.present?
        # 先获取所有符合条件的材料与样品
        material_and_samples = MaterialAndSample.where('material_level IN (2,3)')
          .where('material_name LIKE :keywords OR parent_material_name LIKE :keywords OR grandpa_material_name LIKE :keywords', keywords: "%#{@q}%")
        material_ids = material_and_samples.pluck(:material_id).uniq
        sample_ids = material_and_samples.pluck(:sample_id).uniq.select { |sample_id| sample_id.present? }

        # 再查出这些材料或样品关联的案例
        case_materials = CasesMaterial.where('(type_id = 2 AND material_id IN (?)) OR (type_id = 1 AND sample_id IN (?))', material_ids, sample_ids)

        Cases.where(
          '(id IN (:ids)) OR project_name LIKE :keywords OR business_type LIKE :keywords OR project_type LIKE :keywords OR project_location LIKE :keywords OR design_unit LIKE :keywords',
          keywords: "%#{@q}%",
          ids: case_materials.pluck(:case_id)
        )
      else
        Cases.none
      end

      @manufacturers = if @q.present?
        mat_q_ids = q_return_mat_ids(@q)
        if mat_q_ids.present?
          manu_ids = Manufacturer.joins(:materials).where(materials: { id: mat_q_ids }).pluck(:id)
          Manufacturer.where(id: manu_ids)
        else
          Manufacturer.where('name LIKE ? OR location LIKE ? OR contact LIKE ? OR contact_information LIKE ? OR address LIKE ? OR website LIKE ?',
            "%#{@q}%", "%#{@q}%", "%#{@q}%", "%#{@q}%", "%#{@q}%", "%#{@q}%").sort_by_logo(:desc).order(is_allow: :desc)
        end
      else
        Manufacturer.none
      end

      @news = if @q.present?
        mat_q_ids = q_return_mat_ids(@q)
        if mat_q_ids.present?
          News.where(material_id: mat_q_ids)
        else
          News.all
        end.or(News.where('title LIKE ? OR subtitle LIKE ? OR mold_name LIKE ?', "%#{@q}%", "%#{@q}%", "%#{@q}%"))
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
