class FavouritesController < ApplicationController
  def set_favourite_room
    set_favourite(Room)
  end

  def set_favourite_building
    set_favourite(Building)
  end

  def set_favourite_location
    set_favourite(Location)
  end

  def set_favourite_person
    set_favourite(Person)
  end

  def list
    @favourites = current_user.favourites.order('id DESC')
  end

  private

  def set_favourite(model)
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

  def show_path_for_favourite(favourite)
    path = nil
    case favourite.favourable_type
    when 'Room'
      path = rooms_path
    when 'Building'
      path = buildings_path
    when 'Location'
      path = locations_path
    when 'Person'
      path = people_path
    end
    path
    end
end
