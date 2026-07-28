class InspectionsController < ApplicationController
  def index
    @visits = InspectionVisit.includes(:address).order(visit_date: :desc)
    @visits = @visits.where(status: params[:status]) if params[:status].present?
  end
end
