class CreateAssetInspectionRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :asset_inspection_records do |t|
      t.references :asset, null: false, foreign_key: true
      t.references :inspection_visit, null: false, foreign_key: true
      t.integer :defect_status, null: false, default: 4
      t.text :defect_found
      t.text :action_required

      t.timestamps
    end
    add_index :asset_inspection_records, [:asset_id, :inspection_visit_id], unique: true
    add_index :asset_inspection_records, :defect_status
  end
end
