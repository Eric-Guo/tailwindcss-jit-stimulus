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
  end

  def news
  end

  private

    def set_q_params
      @q = params[:q]
    end
end
