class DefectsController < ApplicationController
  STATUS_TRANSITIONS = { "logged" => "quoted", "quoted" => "scheduled", "scheduled" => "resolved" }.freeze

  def index
    @defects_by_status = Defect.includes(asset: :address).recent_first.group_by(&:status)
  end

  def new
    @defect = Defect.new(asset_id: params[:asset_id])

    if params[:asset_inspection_record_id].present?
      record = AssetInspectionRecord.find(params[:asset_inspection_record_id])
      @defect.asset_inspection_record = record
      @defect.asset_id = record.asset_id
      @defect.description = record.defect_found
    end
  end

  def create
    @defect = Defect.new(defect_params)
    if @defect.save
      redirect_to defects_path, notice: "Defect logged."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    defect
  end

  def update
    if defect.update(defect_params)
      redirect_to defects_path, notice: "Defect updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def advance
    next_status = STATUS_TRANSITIONS.fetch(defect.status, nil)
    if next_status
      defect.update!(status: next_status, resolved_on: next_status == "resolved" ? Date.current : nil)
      redirect_to defects_path, notice: "Defect moved to #{next_status.humanize}."
    else
      redirect_to defects_path, alert: "This defect is already resolved."
    end
  end

  def destroy
    defect.destroy
    redirect_to defects_path, notice: "Defect removed.", status: :see_other
  end

  private

  def defect
    @defect ||= Defect.find(params[:id])
  end

  def defect_params
    params.require(:defect).permit(
      :asset_id, :asset_inspection_record_id, :description, :priority,
      :status, :quote_reference, :scheduled_on, :assigned_to
    )
  end
end
