class FavouriteRoomsController < ApplicationController

  def favourite
    @room = Room.find(params[:id])
    favourite = params[:favourite]

    if favourite
      if not current_user.favourites.include? @room
        current_user.favourites << @room
      end
    else
      current_user.favourites.delete(@room)
    end
  end

  def favouriteroomlist
    if current_user
      @favourite_rooms = current_user.favourite_rooms
    end
  end

end
