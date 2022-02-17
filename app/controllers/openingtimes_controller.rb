class OpeningtimesController < ApplicationController
  before_action :set_openingtime, only: %i[show edit update destroy]
  before_action :add_openingtime, only: %i[create]

  # GET /openingtimes or /openingtimes.json
  def index
    @openingtimes = Openingtime.all
  end

  # GET /openingtimes/1 or /openingtimes/1.json
  def show; end

  # GET /openingtimes/new
  def new
    @openingtime = Openingtime.new
  end

  # GET /openingtimes/1/edit
  def edit; end

  # GET /openingtimes/editForUser/:userid
  def edit_for_user; end

  # POST /openingtimes or /openingtimes.json
  def create
    respond_to do |format|
      if @openingtime.save
        render_success format, 'model.success.create', :created
      else
        render_errors format, :new
      end
    end
  end

  # PATCH/PUT /openingtimes/1 or /openingtimes/1.json
  def update
    respond_to do |format|
      if @openingtime.update(openingtime_params)
        render_success format, 'model.success.update', :ok
      else
        render_errors format, :edit
      end
    end
  end

  # DELETE /openingtimes/1 or /openingtimes/1.json
  def destroy
    @openingtime.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_openingtime
    @openingtime = Openingtime.find(params[:id])
  end

  def add_openingtime
    @openingtime = Openingtime.new(openingtime_params)
  end

  def render_errors(format, route)
    format.html { render route, status: :unprocessable_entity }
    format.json { render json: @openingtime.errors, status: :unprocessable_entity }
  end

  def render_success(format, method, status)
    format.html do
      redirect_to edit_openingtime_path(@openingtime),
                  notice: t(method, model: t('locations.openingtimes.one'))
    end
    format.json { render :edit, status: status, location: @openingtime }
  end

  # Only allow a list of trusted parameters through.
  def openingtime_params
    params.require(:openingtime).permit(:opens, :closes, :day, :timeable_id, :timeable_type)
  end
end
