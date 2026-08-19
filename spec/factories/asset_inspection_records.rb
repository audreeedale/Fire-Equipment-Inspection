FactoryBot.define do
  factory :asset_inspection_record do
    asset
    inspection_visit
    defect_status { :none }
  end
end
