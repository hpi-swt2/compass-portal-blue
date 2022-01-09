class AddUserIdToLocations < ActiveRecord::Migration[6.1]
  def change
    add_column :locations, :user_id, :integer
  end
end
