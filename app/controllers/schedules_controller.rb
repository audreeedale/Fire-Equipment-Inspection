class SchedulesController < ApplicationController
  def new
    @schedule = address.schedules.new(start_date: Date.current)
  end

  def create
    @schedule = address.schedules.new(schedule_params)
    if @schedule.save
      redirect_to address, notice: "Schedule added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    schedule
  end

  def update
    if schedule.update(schedule_params)
      redirect_to schedule.address, notice: "Schedule updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    parent = schedule.address
    schedule.destroy
    redirect_to parent, notice: "Schedule removed.", status: :see_other
  end

  private

  def address
    @address ||= Address.find(params[:address_id])
  end

  def schedule
    @schedule ||= Schedule.find(params[:id])
  end

  def schedule_params
    params.require(:schedule).permit(
      :building_id, :equipment_category, :frequency, :start_date,
      :grace_period_days, :active, :description
    )
  end
end
