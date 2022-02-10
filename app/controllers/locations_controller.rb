class LocationsController < ApplicationController
  load_and_authorize_resource
  before_action :set_location, only: %i[show edit update destroy]

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
    @location = Location.new(location_params)
    @location.owners = [current_user]
    respond_to do |format|
      if @location.save
        format.html { redirect_to edit_location_path(@location), notice: "location was successfully created." }
        format.json { render :edit, status: :created, location: @location }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  # PATCH/PUT /locations/1 or /locations/1.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to edit_location_path(@location), notice: "location was successfully updated." }
        format.json { render :edit, status: :ok, location: @location }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1 or /locations/1.json
  def destroy
    @location.destroy
    respond_to do |format|
      format.html { redirect_to locations_url, notice: "Location was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_location
    @location = Location.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def location_params
    params.require(:location).permit(:name, :details, :location_latitude, :location_longitude, :location_photo,
                                     { openingtimes_attributes: [:id, :day, :opens, :closes] })
  end
end
