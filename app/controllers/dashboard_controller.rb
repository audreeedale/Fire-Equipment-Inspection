class DashboardController < ApplicationController
  def index
    @addresses = Address.includes(:schedules).order(:suburb, :name)

    @inspections_this_month_count = InspectionVisit.where(
      visit_date: Date.current.beginning_of_month..Date.current.end_of_month
    ).count
    @due_soon_count = Schedule.due_soon_count
    @open_defects_count = Defect.open_defects.count

    @todays_visits = InspectionVisit.includes(:address).where(visit_date: Date.current)
    @recent_addresses = Address.order(updated_at: :desc).limit(5)
    @priority_defects = Defect.open_defects.includes(asset: :address).order(priority: :desc).limit(5)
  end
end
