class RenameFavouriteRooms < ActiveRecord::Migration[6.1]
  def change
    rename_table :favourite_rooms, :favourites
  end
end
