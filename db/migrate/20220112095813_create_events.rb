class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.datetime :d_start
      t.datetime :d_end
      t.text :recurring

      t.timestamps
    end
  end
end
