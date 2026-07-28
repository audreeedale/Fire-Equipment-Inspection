class CreateAssets < ActiveRecord::Migration[8.1]
  def change
    create_table :assets do |t|
      t.references :address, null: false, foreign_key: true
      t.references :building, foreign_key: true
      t.string :asset_no, null: false
      t.integer :category, null: false
      t.string :level
      t.string :area
      t.jsonb :details, null: false, default: {}
      t.boolean :active, null: false, default: true

      t.timestamps
    end
    add_index :assets, [:address_id, :asset_no], unique: true
    add_index :assets, :category
    add_index :assets, :details, using: :gin
  end
end
