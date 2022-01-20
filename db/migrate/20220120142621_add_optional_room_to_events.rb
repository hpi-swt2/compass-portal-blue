class AddOptionalRoomToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :room_id, :integer
  end
end
