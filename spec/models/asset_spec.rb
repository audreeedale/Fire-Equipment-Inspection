require "rails_helper"

RSpec.describe Asset, type: :model do
  it "requires asset_no to be unique within the same address" do
    address = create(:address)
    create(:asset, address: address, asset_no: "EXT-1")
    duplicate = build(:asset, address: address, asset_no: "EXT-1")
    expect(duplicate).not_to be_valid
  end

  describe ".active" do
    it "only returns active assets" do
      active_asset = create(:asset, active: true)
      create(:asset, active: false)
      expect(Asset.active).to eq([ active_asset ])
    end
  end

  describe "#latest_record" do
    it "returns the asset inspection record from the most recent visit" do
      asset = create(:asset)
      older_visit = create(:inspection_visit, address: asset.address, visit_date: 10.days.ago.to_date)
      newer_visit = create(:inspection_visit, address: asset.address, visit_date: 1.day.ago.to_date)
      create(:asset_inspection_record, asset: asset, inspection_visit: older_visit)
      newest_record = create(:asset_inspection_record, asset: asset, inspection_visit: newer_visit)

      expect(asset.latest_record).to eq(newest_record)
    end
  end
end
