require "date"

class Users::GeoLocationsController < ApplicationController
  # FIXME: this should be cleaned every now and then
  # Maps from user ids to (location, timestamp) tuples
  @@locations = Concurrent::Hash.new

  def update_geo_location
    return head :unauthorized unless user_signed_in?

    # TODO: should we validate that only exactly those are keys? maybe we
    # lock ourself out of passing metadata / force us to clean out csrf
    # tokens etc. beforehand?
    location = params.require(:location)
    unless RoutingHelper.valid_coordinates?(location)
      return render(status: :bad_request,
                    plain: "Invalid coordinates")
    end

    @@locations[current_user.id] = [location, DateTime.now]
  end
end
