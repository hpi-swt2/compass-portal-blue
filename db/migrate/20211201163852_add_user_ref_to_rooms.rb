class AddUserRefToRooms < ActiveRecord::Migration[6.1]
  def change
    add_reference :rooms, :user, default: nil, foreign_key: true
  end
end
