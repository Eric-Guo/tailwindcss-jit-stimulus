class CreateUserDownloadLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :user_download_logs do |t|
      t.integer :type_id, index: true, limit: 1, default: nil
      t.string :clerk_code, index: true, default: ''
      t.integer :case_id, index: true, default: nil
      t.integer :lmkzsc_id, index: true, default: nil
      t.integer :document_id, index: true, default: nil
      t.timestamps
    end
  end
end
