class BuildingsController < ApplicationController
  def new
    @building = address.buildings.new
  end

  def create
    @building = address.buildings.new(building_params)
    if @building.save
      redirect_to address, notice: "Building added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    building
  end

  def update
    if building.update(building_params)
      redirect_to building.address, notice: "Building updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    parent = building.address
    building.destroy
    redirect_to parent, notice: "Building removed.", status: :see_other
  end

  private

  def address
    @address ||= Address.find(params[:address_id])
  end

  def building
    @building ||= Building.find(params[:id])
  end

  def building_params
    params.require(:building).permit(:name)
  end
end
