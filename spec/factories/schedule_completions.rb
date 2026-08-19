FactoryBot.define do
  factory :schedule_completion do
    schedule
    inspection_visit
    completed_on { Date.current }
  end
end
