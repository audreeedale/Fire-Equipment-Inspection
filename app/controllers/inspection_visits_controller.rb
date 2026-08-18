class InspectionVisitsController < ApplicationController
  def index
    @visits = address.inspection_visits.recent_first
  end

  def new
    @visit = address.inspection_visits.new(visit_date: Date.current)
  end

  def create
    @visit = address.inspection_visits.new(visit_params)
    if @visit.save
      redirect_to address_inspection_visit_asset_inspection_records_path(address, @visit), notice: "Visit started."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    address
    visit
  end

  private

  def address
    @address ||= Address.find(params[:address_id])
  end

  def visit
    @visit ||= InspectionVisit.find(params[:id])
  end

  def visit_params
    params.require(:inspection_visit).permit(:visit_date, :inspector_name, :summary_notes)
  end
end
