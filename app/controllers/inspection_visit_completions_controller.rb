class InspectionVisitCompletionsController < ApplicationController
  def create
    visit.complete!(params[:schedule_ids])
    redirect_to address_inspection_visit_path(address, visit), notice: "Visit completed."
  end

  private

  def address
    @address ||= Address.find(params[:address_id])
  end

  def visit
    @visit ||= InspectionVisit.find(params[:inspection_visit_id])
  end
end
