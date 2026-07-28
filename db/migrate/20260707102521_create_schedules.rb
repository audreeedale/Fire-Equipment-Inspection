class CreateSchedules < ActiveRecord::Migration[8.1]
  def change
    create_table :schedules do |t|
      t.references :address, null: false, foreign_key: true
      t.references :building, foreign_key: true
      t.integer :equipment_category
      t.integer :frequency, null: false, default: 0
      t.date :start_date, null: false
      t.date :last_completed_on
      t.date :next_due_on, null: false
      t.integer :grace_period_days, null: false, default: 7
      t.boolean :active, null: false, default: true
      t.text :description

      t.timestamps
    end
    add_index :schedules, :next_due_on
    add_index :schedules, [:address_id, :equipment_category]
  end
end
