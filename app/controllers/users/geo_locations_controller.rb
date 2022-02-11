class Users::GeoLocationsController < ApplicationController
  def update
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

  def delete
    return head :unauthorized unless user_signed_in?

    deleted = current_user.delete_last_known_location

    return render status: :not_found, plain: "No `location` to delete" if deleted.nil?
  end
end
