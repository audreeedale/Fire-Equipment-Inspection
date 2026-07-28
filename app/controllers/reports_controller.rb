class ReportsController < ApplicationController
  def index
    @months = 5.downto(0).map { |i| i.months.ago.to_date.beginning_of_month }
    completed_by_month = InspectionVisit.completed
      .where(visit_date: @months.first..Date.current.end_of_month)
      .group_by { |visit| visit.visit_date.beginning_of_month }
      .transform_values(&:count)
    @visits_per_month = @months.map { |month| completed_by_month[month] || 0 }

    @completion_rate = percentage(InspectionVisit.completed.count, InspectionVisit.count)
    @defect_resolution_rate = percentage(Defect.resolved.count, Defect.count)
  end

  def compliance
    @addresses = Address.includes(:schedules).order(:suburb, :name)
  end

  def defect_register
    @defects = Defect.includes(asset: :address).recent_first
    @defects = @defects.where(status: params[:status]) if params[:status].present?
    @defects = @defects.where(priority: params[:priority]) if params[:priority].present?
  end

  private

  def percentage(numerator, denominator)
    return 0 if denominator.zero?
    (numerator.to_f / denominator * 100).round
  end
end
