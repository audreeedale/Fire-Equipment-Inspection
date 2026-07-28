FactoryBot.define do
  factory :address do
    sequence(:street_address) { |n| "#{n} Test Street" }
    suburb { "Parramatta" }
    state { "NSW" }
    postcode { "2150" }
  end
end
