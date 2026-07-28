class AssetInspectionRecordsController < ApplicationController
  def update
    if record.update(record_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to sheet_address_inspection_visit_path(record.inspection_visit.address, record.inspection_visit) }
      end
    else
      respond_to do |format|
        format.turbo_stream { render status: :unprocessable_entity }
        format.html do
          redirect_to sheet_address_inspection_visit_path(record.inspection_visit.address, record.inspection_visit),
            alert: record.errors.full_messages.to_sentence
        end
      end
    end
  end

  private

  def record
    @record ||= AssetInspectionRecord.find(params[:id])
  end

  def record_params
    params.require(:asset_inspection_record).permit(:defect_status, :defect_found, :action_required, photos: [])
  end
end
