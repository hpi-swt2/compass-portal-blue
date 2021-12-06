class ApplicationController < ActionController::Base
  # https://github.com/heartcombo/devise#configuring-models
  # Add additional allowed params for Users. Only include this code in devise controllers
  # This is a convenient way to customize devise controllers without creating a new ones
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # 'username' is an attribute not known to devise by default
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :first_name, :last_name, :phone_number])
    devise_parameter_sanitizer.permit(
      :account_update, keys: [:username, :first_name, :last_name, :phone_number, :rooms,
                              { openingtimes_attributes: [:id, :day, :opens, :closes] }]
    )
  end
end
