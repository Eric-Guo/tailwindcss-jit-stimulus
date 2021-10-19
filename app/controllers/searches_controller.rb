# frozen_string_literal: true

class SearchesController < ApplicationController
  before_action :set_q_params

  def material
    @materials = if @q.present?
      Material.where('name LIKE ?', "%#{@q}%")
    else
      Material.none
    end
  end

  def project
    @cases = if @q.present?
      Cases.where('project_name LIKE ?', "%#{@q}%")
    else
      Cases.none
    end
  end

  def manufacturer
    @manufacturers = if @q.present?
      Manufacturer.where('name LIKE ?', "%#{@q}%")
    else
      Manufacturer.none
    end
  end

  def news
    @news = if @q.present?
      News.where('title LIKE ?', "%#{@q}%").or(News.where('subtitle LIKE ?', "%#{@q}%"))
    else
      News.none
    end
  end

  private

    def set_q_params
      @q = params[:q]
    end
end
