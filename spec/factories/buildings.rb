FactoryBot.define do
  factory :building do
    address
    sequence(:name) { |n| "Building #{n}" }
  end
end
