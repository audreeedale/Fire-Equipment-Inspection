class AssetInspectionRecordsController < ApplicationController
  def index
    visit.seed_records_for_all_assets!
    @address = visit.address
    @visit = visit
    @records_by_category = visit.asset_inspection_records.includes(:asset).group_by { |r| r.asset.category }
    @schedules = visit.address.schedules.active.order(:next_due_on)
  end

  def update
    if record.update(record_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to address_inspection_visit_asset_inspection_records_path(record.inspection_visit.address, record.inspection_visit) }
      end
    else
      respond_to do |format|
        format.turbo_stream { render status: :unprocessable_entity }
        format.html do
          redirect_to address_inspection_visit_asset_inspection_records_path(record.inspection_visit.address, record.inspection_visit),
            alert: record.errors.full_messages.to_sentence
        end
      end
    end
  end

  private

  def visit
    @visit ||= InspectionVisit.find(params[:inspection_visit_id])
  end

  def record
    @record ||= AssetInspectionRecord.find(params[:id])
  end

  def record_params
    params.require(:asset_inspection_record).permit(:defect_status, :defect_found, :action_required, photos: [])
  end
end
