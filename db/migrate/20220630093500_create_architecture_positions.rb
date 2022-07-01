class CreateArchitecturePositions < ActiveRecord::Migration[7.0]
  def change
    create_table :architecture_positions do |t|
      t.string :category
      t.string :code, index: true
      t.string :title
      t.integer :level
      t.timestamps
    end
  end
end
