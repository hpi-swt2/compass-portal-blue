class RemoveRoomFromEvents < ActiveRecord::Migration[6.1]
  def change
    remove_reference :events, :room, null: false, foreign_key: true
  end
end
