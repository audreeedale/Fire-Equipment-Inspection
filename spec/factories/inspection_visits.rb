FactoryBot.define do
  factory :inspection_visit do
    address
    visit_date { Date.current }
    inspector_name { "Test Inspector" }
    status { :in_progress }
  end
end
