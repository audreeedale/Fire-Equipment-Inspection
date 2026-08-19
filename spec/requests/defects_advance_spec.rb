require "rails_helper"

RSpec.describe "Advancing a defect through its workflow", type: :request do
  it "moves the defect to the next status" do
    sign_in create(:user)
    defect = create(:defect, status: :logged)

    patch advance_defect_path(defect)

    expect(response).to redirect_to(defects_path)
    expect(defect.reload.status).to eq("quoted")
  end

  it "sets resolved_on when the defect reaches resolved" do
    sign_in create(:user)
    defect = create(:defect, status: :scheduled)

    patch advance_defect_path(defect)

    expect(defect.reload.status).to eq("resolved")
    expect(defect.resolved_on).to eq(Date.current)
  end

  it "does not advance a defect that is already resolved" do
    sign_in create(:user)
    defect = create(:defect, status: :resolved, resolved_on: 3.days.ago.to_date)

    patch advance_defect_path(defect)

    expect(defect.reload.status).to eq("resolved")
    expect(defect.resolved_on).to eq(3.days.ago.to_date)
  end
end
