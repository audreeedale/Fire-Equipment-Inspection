class CreateDefects < ActiveRecord::Migration[8.1]
  def change
    create_table :defects do |t|
      t.references :asset, null: false, foreign_key: true
      t.references :asset_inspection_record, null: true, foreign_key: true
      t.text :description, null: false
      t.integer :priority, null: false, default: 1
      t.integer :status, null: false, default: 0
      t.string :quote_reference
      t.date :scheduled_on
      t.date :resolved_on
      t.string :assigned_to

      t.timestamps
    end
    add_index :defects, :status
    add_index :defects, :priority
  end
end
