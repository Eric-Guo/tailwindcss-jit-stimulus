class CreateReportViewHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :report_view_histories do |t|
      t.string :controller_name
      t.string :action_name
      t.string :clerk_code
      t.datetime :created_at, null: false
    end
  end
end
