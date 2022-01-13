require "date"

class Users::GeoLocationsController < ApplicationController
  # FIXME: this should be cleaned every now and then
  # Maps from user ids to (location, timestamp) tuples
  @locations = Concurrent::Hash.new

  class << self
    attr_accessor :locations
  end

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

    unless RoutingHelper.valid_coordinates?(location)
      return render status: :bad_request, plain: "Invalid coordinates"
    end

    self.class.locations[current_user.id] = [location, DateTime.now]
  end
end
