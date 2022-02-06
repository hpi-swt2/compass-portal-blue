class DeleteJoinTableRoomsUsers < ActiveRecord::Migration[6.1]
  def change
    drop_join_table :rooms, :users
  end
end
