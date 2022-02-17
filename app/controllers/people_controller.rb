class PeopleController < ApplicationController
  before_action :set_person, only: %i[show edit update destroy]
  before_action :add_person, only: %i[create]

  load_and_authorize_resource
  # GET /people or /people.json
  def index
    @people = Person.all
  end

  # GET /people/1 or /people/1.json
  def show; end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit; end

  # POST /people or /people.json
  # rubocop:disable Metrics/MethodLength
  def create
    @person.owners = [current_user]
    respond_to do |format|
      if @person.save
        format.html do
          redirect_to edit_user_registration_path, notice: t('model.success.create', model: t('people.one'))
        end
        format.json { render :edit, status: :created, location: @person }
      else
        render_errors format, :new
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  # PATCH/PUT /people/1 or /people/1.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        format.html do
          redirect_to edit_user_registration_path, notice: t('model.success.update', model: t('people.one'))
        end
        format.json { render :edit, status: :ok, location: @person }
      else
        render_errors format, :edit
      end
    end
  end

  # DELETE /people/1 or /people/1.json
  def destroy
    @person.destroy
    respond_to do |format|
      format.html do
        redirect_to edit_user_registration_path, notice: t('model.success.destroy', model: t('people.one'))
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_person
    @person = Person.find(params[:id])
  end

  def add_person
    @person = Person.new(person_params)
  end

  def render_errors(format, route)
    format.html { render route, status: :unprocessable_entity }
    format.json { render json: @person.errors, status: :unprocessable_entity }
  end

  # Only allow a list of trusted parameters through.
  def person_params
    params.require(:person).permit(:phone_number, :first_name, :last_name, :email, { room_ids: [] }, :profile_picture,
                                   { openingtimes_attributes: [:id, :day, :opens, :closes] })
  end
end
