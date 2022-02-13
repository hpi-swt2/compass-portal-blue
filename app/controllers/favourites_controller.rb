class FavouritesController < ApplicationController
  def set_favourite_room
    @room = Room.find(params[:id])
    is_favourite = params[:favourite]

    if is_favourite
      if !current_user.favourite_rooms.include? @room
        favourite = Favourite.new({user: current_user, favourable: @room})
        if favourite.save
          current_user.favourites << favourite
          @room.favourites << favourite
        else
          head 500
        end
      end
    else
      current_user.favourite_rooms.delete(@room)
    end
  end

  def list
    @favourites = current_user.favourites.order('id DESC') if current_user
  end
end
