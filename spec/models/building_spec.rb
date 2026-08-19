require "rails_helper"

RSpec.describe Building, type: :model do
  it "requires a name" do
    building = build(:building, name: nil)
    expect(building).not_to be_valid
  end

  it "requires the name to be unique within the same address" do
    address = create(:address)
    create(:building, address: address, name: "Main Building")
    duplicate = build(:building, address: address, name: "Main Building")
    expect(duplicate).not_to be_valid
  end

  it "allows the same building name across different addresses" do
    create(:building, name: "Main Building")
    other_address_building = build(:building, name: "Main Building")
    expect(other_address_building).to be_valid
  end
end
