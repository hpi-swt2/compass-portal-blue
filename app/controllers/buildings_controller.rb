class BuildingsController < ApplicationController
  load_and_authorize_resource
  before_action :set_building, only: %i[show edit update destroy]

  # GET /buildings or /buildings.json
  def index
    @buildings = Building.all
  end

  # GET /buildings/1 or /buildings/1.json
  def show; end

  # GET /buildings/new
  def new
    @building = Building.new
    @latitude = params[:lat]
    @longitude = params[:long]
  end

  # GET /buildings/1/edit
  def edit; end

  # POST /buildings or /buildings.json
  # rubocop:disable Metrics/MethodLength
  def create
    @building = Building.new(building_params)
    @building.owners = [current_user]
    respond_to do |format|
      if @building.save
        format.html { redirect_to edit_user_registration_path, notice: t('model.success.create', model: t('buildings.one')) }
        format.json { render :edit, status: :created, location: @building }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @building.errors, status: :unprocessable_entity }
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  # PATCH/PUT /buildings/1 or /buildings/1.json
  def update
    respond_to do |format|
      if @building.update(building_params)
        format.html { redirect_to edit_user_registration_path, notice: t('model.success.update', model: t('buildings.one')) }
        format.json { render :edit, status: :ok, location: @building }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @building.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /buildings/1 or /buildings/1.json
  def destroy
    @building.destroy
    respond_to do |format|
      format.html { redirect_to edit_user_registration_path, notice: t('model.success.destroy', model: t('buildings.one')) }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_building
    @building = Building.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def building_params
    params.require(:building).permit(:name, :location_latitude, :location_longitude)
  end
end
