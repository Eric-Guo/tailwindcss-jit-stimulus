# frozen_string_literal: true

class Notification < ApplicationRecord
  self.table_name = 'notifications'
  
  default_scope { where(deleted_at: nil) }

  def format_data
    return @_format_data if @_format_data.present?
    @_format_data = if data.present?
      if data.is_a?(Hash)
        data
      else
        JSON.parse(data).with_indifferent_access
      end
    else
      nil
    end
    @_format_data
  end

  def msg
    format_data&.fetch(:description, nil) || format_data&.fetch(:demands, {})&.fetch(:description, '')
  end
end
