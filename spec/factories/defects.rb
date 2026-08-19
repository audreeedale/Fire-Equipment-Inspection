FactoryBot.define do
  factory :defect do
    asset
    description { "Pressure gauge reading low" }
    priority { :medium }
    status { :logged }
  end
end
