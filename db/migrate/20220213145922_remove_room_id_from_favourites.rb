class RemoveRoomIdFromFavourites < ActiveRecord::Migration[6.1]
  def change
    remove_column :favourites, :room_id, :integer
  end
end
