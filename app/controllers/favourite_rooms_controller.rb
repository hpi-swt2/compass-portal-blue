class FavouriteRoomsController < ApplicationController
  def favourite
    @room = Room.find(params[:id])
    favourite = params[:favourite]

    if favourite
      current_user.favourites << @room unless current_user.favourites.include? @room
    else
      current_user.favourites.delete(@room)
    end
  end

  def list
    @favourite_rooms = current_user.favourite_rooms if current_user
  end
end
