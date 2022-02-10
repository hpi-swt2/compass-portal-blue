class AddRoomToEvents < ActiveRecord::Migration[6.1]
  def change
    add_reference :events, :room, null: true, foreign_key: true
  end
end
