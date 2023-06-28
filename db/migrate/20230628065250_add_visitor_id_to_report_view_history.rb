class AddVisitorIdToReportViewHistory < ActiveRecord::Migration[7.0]
  def change
    add_column :report_view_histories, :visitor_id, :integer, limit: 8, null: true, default: nil
  end
end
