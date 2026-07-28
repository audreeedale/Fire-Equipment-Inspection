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
      redirect_to sheet_address_inspection_visit_path(address, @visit), notice: "Visit started."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    address
    visit
  end

  def sheet
    visit.seed_records_for_all_assets!
    @records_by_category = visit.asset_inspection_records.includes(:asset).group_by { |r| r.asset.category }
    @schedules = address.schedules.active.order(:next_due_on)
  end

  def complete
    ActiveRecord::Base.transaction do
      visit.update!(status: :completed)
      Array(params[:schedule_ids]).reject(&:blank?).each do |schedule_id|
        ScheduleCompletion.find_or_create_by!(schedule_id: schedule_id, inspection_visit: visit) do |completion|
          completion.completed_on = visit.visit_date
        end
      end
    end
    redirect_to address_inspection_visit_path(address, visit), notice: "Visit completed."
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
