class Users::GeoLocationsController < ApplicationController
  def update_geo_location
    return head :unauthorized unless user_signed_in?

    begin
      # TODO: should we validate that only exactly those are keys? maybe we
      # lock ourself out of passing metadata / force us to clean out csrf
      # tokens etc. beforehand?
      location = params.require(:location)
    rescue ActionController::ParameterMissing
      # TODO: find out why this isn't done automatically
      return render status: :bad_request, plain: "Missing field `location`"
    end

    return render status: :bad_request, plain: "Invalid coordinates" unless RoutingHelper.valid_coordinates?(location)

    current_user.update_last_known_location(location)
  end

  # TODO: add DELETE route
  # A test already exists in user_geolocation_spec.rb that is currently skipped :^)
  def delete_geo_location
    return head :unauthorized unless user_signed_in?

    if current_user.delete_last_known_location.nil?
      return render status: :not_found, plain: "No `location` to delete"
    end

  end
end
