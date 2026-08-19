Defect.destroy_all
AssetInspectionRecord.destroy_all
ScheduleCompletion.destroy_all
InspectionVisit.destroy_all
Asset.destroy_all
Schedule.destroy_all
Building.destroy_all
Address.destroy_all

# Dev login: admin@emberinspect.com / password
User.find_or_create_by!(email: "admin@emberinspect.com") do |user|
  user.name = "Alex Morgan"
  user.password = "password"
end

nsw_sites = [
  { suburb: "Parramatta", postcode: "2150" },
  { suburb: "Chatswood", postcode: "2067" },
  { suburb: "Liverpool", postcode: "2170" },
  { suburb: "Bondi Junction", postcode: "2022" }
]

nsw_sites.each_with_index do |site, i|
  address = Address.create!(
    name: "#{Faker::Company.name} Site #{i + 1}",
    street_address: Faker::Address.street_address,
    suburb: site[:suburb],
    state: "NSW",
    postcode: site[:postcode],
    contact_name: Faker::Name.name,
    contact_phone: Faker::PhoneNumber.phone_number,
    contact_email: Faker::Internet.email
  )

  main_building = address.buildings.create!(name: "Main Building")
  address.buildings.create!(name: "Carpark") if i.zero?

  annual = address.schedules.create!(frequency: :annual, start_date: 11.months.ago.to_date, equipment_category: nil, description: "Whole-site annual inspection")
  monthly = address.schedules.create!(frequency: :monthly, start_date: 25.days.ago.to_date, equipment_category: :fire_extinguisher, description: "Extinguisher monthly check")
  address.schedules.create!(frequency: :six_monthly, start_date: 5.months.ago.to_date, equipment_category: :exit_light, description: "Exit light 6-monthly check")

  5.times do |n|
    address.assets.create!(
      building: main_building, asset_no: "EXT-#{i}-#{n}", category: :fire_extinguisher,
      level: "Level #{n % 3 + 1}", area: "Corridor #{n}",
      details: { size_and_type: ["4.5kg ABE", "9L Water", "2kg CO2"].sample }
    )
  end

  2.times do |n|
    address.assets.create!(
      building: main_building, asset_no: "HYD-#{i}-#{n}", category: :hydrant,
      level: "Ground", area: "Stairwell #{n + 1}",
      details: { size_and_type: "Hose reel cabinet" }
    )
  end

  3.times do |n|
    address.assets.create!(
      building: main_building, asset_no: "EX-#{i}-#{n}", category: :exit_light,
      level: "Level #{n % 3 + 1}",
      details: { type_code: %w[EMG EX].sample, brand: "Clevertronics", length: "600mm" }
    )
  end

  2.times do |n|
    address.assets.create!(
      building: main_building, asset_no: "FD-#{i}-#{n}", category: :fire_door,
      level: "Level #{n + 1}", details: { type_code: "FD" }
    )
  end

  1.times do |n|
    address.assets.create!(
      building: main_building, asset_no: "SA-#{i}-#{n}", category: :smoke_alarm,
      level: "Level 1", details: { type_code: "SA" }
    )
  end

  visit = address.inspection_visits.create!(
    visit_date: 25.days.ago.to_date, inspector_name: Faker::Name.name, status: :completed
  )
  visit.seed_records_for_all_assets!

  defective = visit.asset_inspection_records.joins(:asset).where(assets: { category: Asset.categories[:fire_extinguisher] }).limit(2)
  defective.each do |record|
    record.update!(defect_status: :non_critical, defect_found: "Pressure gauge reading low", action_required: "Recharge and retest")
  end

  first_defective_record = defective.first
  if first_defective_record
    Defect.create!(
      asset: first_defective_record.asset,
      asset_inspection_record: first_defective_record,
      description: first_defective_record.defect_found,
      priority: :medium,
      status: %i[logged quoted scheduled].sample,
      assigned_to: Faker::Name.name
    )
  end

  ScheduleCompletion.create!(schedule: monthly, inspection_visit: visit, completed_on: visit.visit_date)
end

puts "Seeded #{Address.count} addresses, #{Asset.count} assets, #{Schedule.count} schedules, #{InspectionVisit.count} visits, #{Defect.count} defects, #{User.count} users."
