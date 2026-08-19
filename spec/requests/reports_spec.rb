require "rails_helper"
require "nokogiri"

RSpec.describe "Reports", type: :request do
  it "reports the completion and defect resolution rates" do
    sign_in create(:user)

    create(:inspection_visit, status: :completed, visit_date: Date.current)
    create(:inspection_visit, status: :in_progress, visit_date: Date.current)

    create(:defect, status: :resolved)
    create(:defect, status: :logged)

    get reports_path

    expect(response).to have_http_status(:ok)

    rates = Nokogiri::HTML(response.body).css(".flex.justify-between.text-sm.mb-1 strong").map { |el| el.text.strip }
    expect(rates).to eq([ "50%", "50%" ])
  end

  it "counts completed inspection visits per month for the trend chart" do
    sign_in create(:user)

    create_list(:inspection_visit, 3, status: :completed, visit_date: Date.current.beginning_of_month)
    create_list(:inspection_visit, 1, status: :completed, visit_date: 1.month.ago.beginning_of_month)
    create(:inspection_visit, status: :in_progress, visit_date: Date.current)

    get reports_path

    heights = Nokogiri::HTML(response.body).css(".flex-1.h-full.flex.flex-col.justify-end.items-center.gap-2 > div").map { |el| el["style"] }
    expect(heights.last).to eq("height: 100%")
    expect(heights[-2]).to eq("height: 33%")
  end
end
