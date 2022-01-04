class AddRequestPathToReportViewHistory < ActiveRecord::Migration[7.0]
  def change
    add_column :report_view_histories, :request_path, :text
  end
end
