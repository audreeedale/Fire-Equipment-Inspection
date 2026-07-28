class CreateInspectionVisits < ActiveRecord::Migration[8.1]
  def change
    create_table :inspection_visits do |t|
      t.references :address, null: false, foreign_key: true
      t.date :visit_date, null: false
      t.string :inspector_name
      t.integer :status, null: false, default: 0
      t.text :summary_notes

      t.timestamps
    end
    add_index :inspection_visits, [:address_id, :visit_date]
    add_index :inspection_visits, :visit_date
  end
end
