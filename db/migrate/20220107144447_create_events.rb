class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :d_start
      t.text :recurring

      t.timestamps
    end
  end
end
