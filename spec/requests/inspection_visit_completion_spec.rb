require "rails_helper"

RSpec.describe "Completing an inspection visit", type: :request do
  it "marks the visit completed and recomputes the linked schedule's next due date" do
    sign_in create(:user)

    address = create(:address)
    schedule = create(:schedule, address: address, frequency: :monthly, start_date: Date.new(2026, 1, 1), next_due_on: Date.new(2026, 2, 1))
    visit = create(:inspection_visit, address: address, visit_date: Date.new(2026, 2, 1))

    patch complete_address_inspection_visit_path(address, visit), params: { schedule_ids: [schedule.id] }

    expect(response).to redirect_to(address_inspection_visit_path(address, visit))
    expect(visit.reload.status).to eq("completed")
    expect(schedule.reload.last_completed_on).to eq(Date.new(2026, 2, 1))
    expect(schedule.reload.next_due_on).to eq(Date.new(2026, 3, 1))
  end
end
