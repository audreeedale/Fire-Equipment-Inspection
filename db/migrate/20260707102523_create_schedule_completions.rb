class CreateScheduleCompletions < ActiveRecord::Migration[8.1]
  def change
    create_table :schedule_completions do |t|
      t.references :schedule, null: false, foreign_key: true
      t.references :inspection_visit, null: false, foreign_key: true
      t.date :completed_on, null: false

      t.timestamps
    end
    add_index :schedule_completions, [ :schedule_id, :inspection_visit_id ], unique: true, name: "idx_schedule_completions_unique"
  end
end
