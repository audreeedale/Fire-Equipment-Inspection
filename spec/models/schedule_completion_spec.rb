require "rails_helper"

RSpec.describe ScheduleCompletion, type: :model do
  it "allows only one completion per schedule per visit" do
    address = create(:address)
    schedule = create(:schedule, address: address)
    visit = create(:inspection_visit, address: address)
    create(:schedule_completion, schedule: schedule, inspection_visit: visit, completed_on: visit.visit_date)
    duplicate = build(:schedule_completion, schedule: schedule, inspection_visit: visit, completed_on: visit.visit_date)
    expect(duplicate).not_to be_valid
  end

  it "marks the linked schedule completed on create" do
    address = create(:address)
    schedule = create(:schedule, address: address, frequency: :monthly, start_date: Date.new(2026, 1, 1), next_due_on: Date.new(2026, 2, 1))
    visit = create(:inspection_visit, address: address, visit_date: Date.new(2026, 2, 1))

    create(:schedule_completion, schedule: schedule, inspection_visit: visit, completed_on: visit.visit_date)

    expect(schedule.reload.last_completed_on).to eq(Date.new(2026, 2, 1))
    expect(schedule.reload.next_due_on).to eq(Date.new(2026, 3, 1))
  end
end
