class AddFavourableToFavourites < ActiveRecord::Migration[6.1]
  def change
    add_reference :favourites, :favourable, polymorphic: true, index: true
  end
end
