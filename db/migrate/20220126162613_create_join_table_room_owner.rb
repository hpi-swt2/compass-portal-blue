class CreateJoinTableRoomOwner < ActiveRecord::Migration[6.1]
  def change
    create_join_table :rooms, :users, table_name: 'room_owner' do |t|
      # t.index [:room_id, :user_id]
      # t.index [:user_id, :room_id]
    end
  end
end
