require "rails_helper"

RSpec.describe Schedule, type: :model do
  describe "#status" do
    it "is upcoming when next_due_on is well beyond the grace period" do
      schedule = build(:schedule, next_due_on: 30.days.from_now.to_date, grace_period_days: 7)
      expect(schedule.status).to eq(:upcoming)
    end

    it "is due_soon when next_due_on falls within the grace period" do
      schedule = build(:schedule, next_due_on: 3.days.from_now.to_date, grace_period_days: 7)
      expect(schedule.status).to eq(:due_soon)
    end

    it "is overdue when next_due_on has passed" do
      schedule = build(:schedule, next_due_on: 1.day.ago.to_date, grace_period_days: 7)
      expect(schedule.status).to eq(:overdue)
    end

    it "is inactive when the schedule is not active, regardless of due date" do
      schedule = build(:schedule, next_due_on: 1.day.ago.to_date, active: false)
      expect(schedule.status).to eq(:inactive)
    end
  end

  describe "next_due_on defaulting on create" do
    it "is set automatically from start_date and frequency when not provided" do
      schedule = create(:schedule, frequency: :monthly, start_date: Date.new(2026, 1, 1), next_due_on: nil)
      expect(schedule.next_due_on).to eq(Date.new(2026, 2, 1))
    end

    it "respects an explicitly provided next_due_on" do
      schedule = create(:schedule, frequency: :monthly, start_date: Date.new(2026, 1, 1), next_due_on: Date.new(2026, 3, 15))
      expect(schedule.next_due_on).to eq(Date.new(2026, 3, 15))
    end
  end

  describe "#mark_completed!" do
    it "advances next_due_on by the frequency interval from the completion date" do
      schedule = create(:schedule, frequency: :six_monthly, start_date: Date.new(2026, 1, 1))
      schedule.mark_completed!(Date.new(2026, 6, 1))
      expect(schedule.last_completed_on).to eq(Date.new(2026, 6, 1))
      expect(schedule.next_due_on).to eq(Date.new(2026, 12, 1))
    end
  end
end
