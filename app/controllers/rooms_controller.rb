class RoomsController < ApplicationController
  load_and_authorize_resource
  before_action :set_room, only: %i[show edit update destroy]

  # GET /rooms or /rooms.json
  def index
    @rooms = Room.all
  end

  # GET /rooms/1 or /rooms/1.json
  def show; end

  # GET /rooms/new
  def new
    @room = Room.new
    @latitude = params[:lat]
    @longitude = params[:long]
  end

  # GET /rooms/1/edit
  def edit; end

  # GET /rooms/1/calendar
  def calendar
    @room = Room.find(params[:room_id])
    start_date = params[:start_date].to_date
    @month = start_date.month
    @year = start_date.year
    @events = Event.generate_calendar_events(@room.events,
                                             start_date.beginning_of_month.beginning_of_week,
                                             start_date.end_of_month.end_of_week).compact
  end

  # POST /rooms or /rooms.json
  # rubocop:disable Metrics/MethodLength
  def create
    @room = Room.new(room_params)
    @room.owners = [current_user]
    respond_to do |format|
      if @room.save
        format.html { redirect_to edit_user_registration_path, notice: "Room was successfully created." }
        format.json { render :edit, status: :created, location: @room }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  # PATCH/PUT /rooms/1 or /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to edit_user_registration_path, notice: "Room was successfully updated." }
        format.json { render :edit, status: :ok, location: @room }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1 or /rooms/1.json
  def destroy
    @room.destroy
    respond_to do |format|
      format.html { redirect_to edit_user_registration_path, notice: "Room was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_room
    @room = Room.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def room_params
    params.require(:room).permit(:name, :floor, :room_type, :building_id,
                                 :location_latitude, :location_longitude, person_ids: [])
  end
end
