class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]
  before_action :add_event, only: %i[create]

  # GET /events or /events.json
  def index
    @events = Event.all
  end

  def import
    if params[:file].nil?
      redirect_to edit_user_registration_path, alert: t('events.alert.choose_file')
    else
      import_ics(params[:file].tempfile)
    end
  end

  # GET /events/1 or /events/1.json
  def show; end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit; end

  # POST /events or /events.json
  def create
    respond_to do |format|
      if @event.save
        format.html do
          redirect_to edit_user_registration_path, notice: t('model.success.create', model: t('events.one'))
        end
        format.json { render :show, status: :created, location: @event }
      else
        render_errors format, :new
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html do
          redirect_to edit_user_registration_path, notice: t('model.success.update', model: t('events.one'))
        end
        format.json { render :show, status: :ok, location: @event }
      else
        render_errors format, :edit
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy

    respond_to do |format|
      format.html do
        redirect_to edit_user_registration_path, notice: t('model.success.destroy', model: t('events.one'))
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  def add_event
    @event = Event.new(event_params)
  end

  def render_errors(format, route)
    format.html { render route, status: :unprocessable_entity }
    format.json { render json: @event.errors, status: :unprocessable_entity }
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:name, :description, :start_time, :end_time, :recurring, :room_id)
  end

  def import_ics(file)
    if File.extname(file.path) == ".ics"
      Event.import(file)
      redirect_to edit_user_registration_path, notice: t('events.import_success')
    else
      redirect_to edit_user_registration_path, alert: t('events.alert.ics_only')
    end
    file.close!
  end
end
