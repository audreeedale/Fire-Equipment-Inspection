FactoryBot.define do
  factory :schedule do
    address
    frequency { :monthly }
    start_date { Date.current }
    grace_period_days { 7 }
    active { true }
  end
end
