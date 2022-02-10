class ApplicationController < ActionController::Base
  # https://github.com/heartcombo/devise#configuring-models
  # Add additional allowed params for Users. Only include this code in devise controllers
  # This is a convenient way to customize devise controllers without creating a new ones
  before_action :configure_permitted_parameters, if: :devise_controller?
  around_action :change_locale

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to '/login', notice: exception.message
  end

  protected

  def configure_permitted_parameters
    # 'username' is an attribute not known to devise by default
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :first_name, :last_name, :phone_number])
    devise_parameter_sanitizer.permit(
      :account_update, keys: [:username, :first_name, :last_name, :phone_number, :rooms, :profile_picture,
                              { openingtimes_attributes: [:id, :day, :opens, :closes] }]
    )
  end

  private

  def change_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.locale = locale
    I18n.with_locale(locale, &action)
  end

  # Automatically add the locale query param (e.g. `?locale=en`) to all requests
  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end
end
