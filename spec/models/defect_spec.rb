require "rails_helper"

RSpec.describe Defect, type: :model do
  it "requires a description" do
    defect = build(:defect, description: nil)
    expect(defect).not_to be_valid
  end

  describe ".open_defects" do
    it "excludes resolved defects" do
      open_defect = create(:defect, status: :logged)
      create(:defect, status: :resolved)
      expect(described_class.open_defects).to eq([ open_defect ])
    end
  end

  describe ".recent_first" do
    it "orders by created_at descending" do
      older = create(:defect, created_at: 2.days.ago)
      newer = create(:defect, created_at: 1.day.ago)
      expect(described_class.recent_first).to eq([ newer, older ])
    end
  end
end
