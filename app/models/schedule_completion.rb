class ScheduleCompletion < ApplicationRecord
  belongs_to :schedule
  belongs_to :inspection_visit

  validates :schedule_id, uniqueness: { scope: :inspection_visit_id }
  validates :completed_on, presence: true

  after_create :apply_to_schedule!

  private

  def apply_to_schedule!
    schedule.mark_completed!(completed_on)
  end
end
