# frozen_string_literal: true

class SamplesController < ApplicationController
  def show
    @sample = Sample.find_by!(no: params[:id])

  end
end
