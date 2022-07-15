class CreateSuperStaffs < ActiveRecord::Migration[7.0]
  def change
    create_table :super_staffs do |t|
      t.string :clerk_code, null: false, index: { unique: true }
      t.timestamps
    end
  end
end
