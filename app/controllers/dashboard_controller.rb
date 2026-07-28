class DashboardController < ApplicationController
  def index
    @addresses = Address.includes(:schedules).order(:suburb, :name)

    @inspections_this_month_count = InspectionVisit.where(
      visit_date: Date.current.beginning_of_month..Date.current.end_of_month
    ).count
    @due_soon_count = Schedule.active.count { |s| s.status == :due_soon }
    @open_defects_count = Defect.open_defects.count
    @compliance_rate = compliance_rate

    @todays_visits = InspectionVisit.includes(:address).where(visit_date: Date.current)
    @recent_addresses = Address.order(updated_at: :desc).limit(5)
    @priority_defects = Defect.open_defects.includes(asset: :address).order(priority: :desc).limit(5)
  end

  private

  def compliance_rate
    scored = @addresses.reject { |a| a.overall_status == :no_schedule }
    return 100 if scored.empty?
    (scored.count { |a| a.overall_status != :overdue }.to_f / scored.size * 100).round(1)
  end
end
