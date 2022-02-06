class CreateJoinTablePeopleRooms < ActiveRecord::Migration[6.1]
  def change
    create_join_table :people, :rooms do |t|
      # t.index [:person_id, :room_id]
      # t.index [:room_id, :person_id]
    end
  end
end
