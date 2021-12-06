class OpeningtimesController < ApplicationController
  before_action :set_openingtime, only: %i[show edit update destroy]

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
    @openingtime = Openingtime.new(openingtime_params)

    respond_to do |format|
      if @openingtime.save
        format.html { redirect_to @openingtime, notice: "Openingtime was successfully created." }
        format.json { render :show, status: :created, location: @openingtime }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @openingtime.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /openingtimes/1 or /openingtimes/1.json
  def update
    respond_to do |format|
      if @openingtime.update(openingtime_params)
        format.html { redirect_to @openingtime, notice: "Openingtime was successfully updated." }
        format.json { render :show, status: :ok, location: @openingtime }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @openingtime.errors, status: :unprocessable_entity }
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

  # Only allow a list of trusted parameters through.
  def openingtime_params
    params.require(:openingtime).permit(:opens, :closes, :day, :timeable_id, :timeable_type)
  end
end
