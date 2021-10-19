# frozen_string_literal: true

class SearchesController < ApplicationController
  before_action :set_q_params

  def material
    @materials = Material.where('name LIKE ?', "%#{@q}%")
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
end
