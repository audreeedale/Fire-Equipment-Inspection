require "rails_helper"
require "nokogiri"

RSpec.describe "Dashboard", type: :request do
  it "shows workload counts for the current data" do
    sign_in create(:user)

    address = create(:address)
    create(:schedule, address: address, next_due_on: 2.days.from_now.to_date, grace_period_days: 7)

    create(:defect, status: :logged)

    get root_path

    expect(response).to have_http_status(:ok)

    stat_values = Nokogiri::HTML(response.body).css(".text-3xl.font-extrabold").map { |el| el.text.strip }
    expect(stat_values).to eq([ "0", "1", "1" ])
  end
end
