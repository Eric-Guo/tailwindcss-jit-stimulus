# frozen_string_literal: true

class ProjectsController < ApplicationController
  def index
    @q = '上海'
    @cases = if @q.present?
      Cases.where('project_name LIKE ? OR business_type LIKE ? OR project_type LIKE ? OR project_location LIKE ? OR design_unit LIKE ?',
        "%#{@q}%", "%#{@q}%", "%#{@q}%", "%#{@q}%", "%#{@q}%")
    else
      Cases.none
    end
  end
end
