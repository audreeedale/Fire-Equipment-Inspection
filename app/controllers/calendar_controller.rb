class CalendarController < ApplicationController
  def index
    @month = parse_month(params[:month]) || Date.current.beginning_of_month
    @visits_by_day = InspectionVisit.includes(:address)
      .where(visit_date: @month.beginning_of_month..@month.end_of_month)
      .group_by(&:visit_date)
    @weeks = weeks_for(@month)
  end

  private

  def parse_month(value)
    return nil if value.blank?
    Date.parse("#{value}-01").beginning_of_month
  rescue ArgumentError
    nil
  end

  def weeks_for(month)
    first_day = month.beginning_of_month.beginning_of_week(:monday)
    last_day = month.end_of_month.end_of_week(:monday)
    (first_day..last_day).each_slice(7).to_a
  end
end
