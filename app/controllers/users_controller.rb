class UsersController < ApplicationController
  load_and_authorize_resource

  def roles
    @users = User.all
  end

  # PATCH/PUT /users/1/roles
  def update_roles
    user = User.find(params[:id])
    user.admin = roles_params[:admin]
    user.save
  end

  # Only allow a list of trusted parameters through.
  def roles_params
    params.require(:roles).permit(:admin)
  end
end
