class AddressesController < ApplicationController
  def index
    @addresses = Address.includes(:schedules, :assets).order(:suburb, :name)
    @open_defect_counts = Defect.open_defects.joins(:asset).group("assets.address_id").count
  end

  def show
    @buildings = address.buildings.order(:name)
    @schedules = address.schedules.active.order(:next_due_on)
    @recent_visits = address.inspection_visits.recent_first.limit(10)
    @assets = address.assets.order(:asset_no)
    @assets_by_category = @assets.active.group_by(&:category)
    @recent_defects = Defect.joins(:asset).where(assets: { address_id: address.id }).recent_first.limit(5)
  end

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)
    if @address.save
      redirect_to @address, notice: "Address created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    address
  end

  def update
    if address.update(address_params)
      redirect_to address, notice: "Address updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    address.destroy
    redirect_to addresses_path, notice: "Address removed.", status: :see_other
  end

  private

  def address
    @address ||= Address.find(params[:id])
  end

  def address_params
    params.require(:address).permit(
      :name, :street_address, :suburb, :state, :postcode,
      :contact_name, :contact_phone, :contact_email, :notes
    )
  end
end
