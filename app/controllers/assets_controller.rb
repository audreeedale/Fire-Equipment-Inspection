class AssetsController < ApplicationController
  def index
    @assets = address.assets.order(:category, :asset_no)
    @assets = @assets.where(category: params[:category]) if params[:category].present?
  end

  def new
    @asset = address.assets.new
  end

  def create
    @asset = address.assets.new(asset_params)
    if @asset.save
      redirect_to address_assets_path(address), notice: "Asset added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    asset
  end

  def update
    if asset.update(asset_params)
      redirect_to address_assets_path(asset.address), notice: "Asset updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    parent = asset.address
    asset.destroy
    redirect_to address_assets_path(parent), notice: "Asset removed.", status: :see_other
  end

  private

  def address
    @address ||= Address.find(params[:address_id])
  end

  def asset
    @asset ||= Asset.find(params[:id])
  end

  def asset_params
    params.require(:asset).permit(
      :building_id, :asset_no, :category, :level, :area, :active,
      :size_and_type, :type_code, :brand, :length
    )
  end
end
