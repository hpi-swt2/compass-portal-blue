class UsersController < ApplicationController
  def roles
    @users = User.all
  end
  
  # PATCH/PUT /buildings/1 or /buildings/1.json
  def update_roles
    puts "user id", params['id']
    puts "should become admin?", roles_params['admin']
    # TODO
  end

  # Only allow a list of trusted parameters through.
  def roles_params
    params.require(:roles).permit(:admin)
  end
end
