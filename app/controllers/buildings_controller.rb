class BuildingsController < ApplicationController
  load_and_authorize_resource
  before_action :set_building, only: %i[show edit update destroy]
  before_action :add_building, only: %i[create]

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
    @building.owners = [current_user]
    respond_to do |format|
      if @building.save
        format.html do
          redirect_to edit_user_registration_path, notice: t('model.success.create', model: t('buildings.one'))
        end
        format.json { render :edit, status: :created, location: @building }
      else
        render_errors format, :new
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  # PATCH/PUT /buildings/1 or /buildings/1.json
  def update
    respond_to do |format|
      if @building.update(building_params)
        format.html do
          redirect_to edit_user_registration_path, notice: t('model.success.update', model: t('buildings.one'))
        end
        format.json { render :edit, status: :ok, location: @building }
      else
        render_errors format, :edit
      end
    end
  end

  # DELETE /buildings/1 or /buildings/1.json
  def destroy
    @building.destroy
    respond_to do |format|
      format.html do
        redirect_to edit_user_registration_path, notice: t('model.success.destroy', model: t('buildings.one'))
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_building
    @building = Building.find(params[:id])
  end

  def add_building
    @building = Building.new(building_params)
  end

  def render_errors(format, route)
    format.html { render route, status: :unprocessable_entity }
    format.json { render json: @building.errors, status: :unprocessable_entity }
  end

  # Only allow a list of trusted parameters through.
  def building_params
    params.require(:building).permit(:name, :name_de, :location_latitude, :location_longitude)
  end
end
