require "rails_helper"

RSpec.describe AssetInspectionRecord, type: :model do
  it "allows only one record per asset per visit" do
    asset = create(:asset)
    visit = create(:inspection_visit, address: asset.address)
    create(:asset_inspection_record, asset: asset, inspection_visit: visit)
    duplicate = build(:asset_inspection_record, asset: asset, inspection_visit: visit)
    expect(duplicate).not_to be_valid
  end

  describe ".with_defects" do
    it "excludes records with no defect" do
      flagged = create(:asset_inspection_record, defect_status: :non_critical)
      create(:asset_inspection_record, defect_status: :none)
      expect(described_class.with_defects).to eq([ flagged ])
    end
  end
end
