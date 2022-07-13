# frozen_string_literal: true

class ManufacturerRecordsController < ApplicationController
  def show
    @manufacturer = ManufacturerRecord.joins(:external_user).where(external_user: { id: params[:id] }).take!()
  end
end
