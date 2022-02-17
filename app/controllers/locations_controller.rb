class LocationsController < ApplicationController
  load_and_authorize_resource
  before_action :set_location, only: %i[show edit update destroy]
  before_action :add_location, only: %i[create]

  # GET /locations or /locations.json
  def index
    @locations = Location.all
  end

  # GET /locations/1 or /locations/1.json
  def show; end

  # GET /locations/new
  def new
    @location = Location.new
    @latitude = params[:lat]
    @longitude = params[:long]
  end

  # GET /locations/1/edit
  def edit; end

  # POST /locations or /locations.json
  # rubocop:disable Metrics/MethodLength
  def create
    @location.owners = [current_user]
    respond_to do |format|
      if @location.save
        format.html do
          redirect_to edit_user_registration_path, notice: t('model.success.create', model: t('locations.one'))
        end
        format.json { render :edit, status: :created, location: @location }
      else
        render_errors format, :new
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  # PATCH/PUT /locations/1 or /locations/1.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html do
          redirect_to edit_user_registration_path, notice: t('model.success.update', model: t('locations.one'))
        end
        format.json { render :edit, status: :ok, location: @location }
      else
        render_errors format, :edit
      end
    end
  end

  # DELETE /locations/1 or /locations/1.json
  def destroy
    @location.destroy
    respond_to do |format|
      format.html do
        redirect_to edit_user_registration_path, notice: t('model.success.destroy', model: t('locations.one'))
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_location
    @location = Location.find(params[:id])
  end

  def add_location
    @location = Location.new(location_params)
  end

  def render_errors(format, route)
    format.html { render route, status: :unprocessable_entity }
    format.json { render json: @location.errors, status: :unprocessable_entity }
  end

  # Only allow a list of trusted parameters through.
  def location_params
    params.require(:location).permit(:name, :details, :location_latitude, :location_longitude, :location_photo,
                                     { openingtimes_attributes: [:id, :day, :opens, :closes] })
  end
end
