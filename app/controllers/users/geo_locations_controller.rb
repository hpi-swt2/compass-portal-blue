require "date"

class Users::GeoLocationsController < ApplicationController

    # FIXME: this is bad, we know (it turns of CSRF checks)
    protect_from_forgery with: :null_session

    # Maps from user ids to (location, timestamp) tuples
    # FIXME: this is not thread safe, but we are multithreaded
    @@locations = {}

    def update_geo_location
      # TODO: should we validate that only exactly those are keys? maybe we
      # lock ourself out of passing metadata / force us to clean out csrf
      # tokens etc. beforehand?
      (user_id, location) = params.require([:user, :location])

      raise ActionController::BadRequest, "Invalid coordinates" unless RoutingHelper.valid_coordinates?(location)
      raise ActionController::BadRequest, "Invalid user id" unless User.exists?(user_id)

      @@locations[user_id] = [location, DateTime.now]
    end
end
