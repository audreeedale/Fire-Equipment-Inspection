require "rails_helper"

RSpec.describe Address, type: :model do
  describe "validations" do
    it "requires street_address, suburb, and postcode" do
      address = described_class.new
      expect(address).not_to be_valid
      expect(address.errors.attribute_names).to include(:street_address, :suburb, :postcode)
    end

    it "requires state (the column defaults to NSW, but blank is still invalid)" do
      address = build(:address, state: "")
      expect(address).not_to be_valid
      expect(address.errors[:state]).to include("can't be blank")
    end

    it "requires a 4-digit postcode" do
      address = build(:address, postcode: "ABCD")
      expect(address).not_to be_valid
      expect(address.errors[:postcode]).to include("must be 4 digits (AU postcode)")
    end
  end

  describe "#display_name" do
    it "uses the given name when present" do
      address = build(:address, name: "Westfield Parramatta")
      expect(address.display_name).to eq("Westfield Parramatta")
    end

    it "falls back to the formatted street address when no name is set" do
      address = build(:address, name: nil, street_address: "1 Test Street", suburb: "Parramatta", state: "NSW", postcode: "2150")
      expect(address.display_name).to eq("1 Test Street, Parramatta NSW 2150")
    end
  end

  describe "#overall_status" do
    it "is no_schedule when the address has no active schedules" do
      address = create(:address)
      expect(address.overall_status).to eq(:no_schedule)
    end

    it "is overdue when any active schedule is overdue" do
      address = create(:address)
      create(:schedule, address: address, next_due_on: 1.day.ago.to_date, grace_period_days: 7)
      create(:schedule, address: address, next_due_on: 30.days.from_now.to_date, grace_period_days: 7)
      expect(address.overall_status).to eq(:overdue)
    end

    it "is due_soon when no schedule is overdue but one is due soon" do
      address = create(:address)
      create(:schedule, address: address, next_due_on: 2.days.from_now.to_date, grace_period_days: 7)
      expect(address.overall_status).to eq(:due_soon)
    end

    it "is upcoming when every active schedule is comfortably in the future" do
      address = create(:address)
      create(:schedule, address: address, next_due_on: 30.days.from_now.to_date, grace_period_days: 7)
      expect(address.overall_status).to eq(:upcoming)
    end
  end
end
