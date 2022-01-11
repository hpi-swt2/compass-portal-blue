require "date"

class Users::GeoLocationsController < ApplicationController

    # FIXME: this is bad, we know (it turns of CSRF checks)
    protect_from_forgery with: :null_session
    skip_before_action :verify_authenticity_token

    # Maps from user ids to (location, timestamp) tuples
    # FIXME: this is not thread safe, but we are multithreaded
    @@locations = {}

    def update_geo_location
      return head :unauthorized unless user_signed_in?

      # TODO: should we validate that only exactly those are keys? maybe we
      # lock ourself out of passing metadata / force us to clean out csrf
      # tokens etc. beforehand?
      location = params.require(:location)
      raise ActionController::BadRequest, "Invalid coordinates" unless RoutingHelper.valid_coordinates?(location)

      @@locations[current_user.id] = [location, DateTime.now]
    end
end
