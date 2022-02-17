class FavouritesController < ApplicationController
  def set_favourite_room
    favourite_set(Room)
  end

  def set_favourite_building
    favourite_set(Building)
  end

  def set_favourite_location
    favourite_set(Location)
  end

  def set_favourite_person
    favourite_set(Person)
  end

  def list
    @favourites = current_user.favourites.order('id DESC') if current_user
  end

  private

  def favourite_set(model)
    instance = model.find(params[:id])
    is_favourite = params[:favourite]

    if is_favourite
      make_favourite(instance)
    else
      instance.favourited_by.delete(current_user)
    end
  end

  def make_favourite(instance)
    instance.favourited_by << current_user unless instance.favourited_by.include? current_user
  end
end
