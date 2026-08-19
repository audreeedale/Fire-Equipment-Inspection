FactoryBot.define do
  factory :asset do
    address
    sequence(:asset_no) { |n| "EXT-#{n}" }
    category { :fire_extinguisher }
  end
end
