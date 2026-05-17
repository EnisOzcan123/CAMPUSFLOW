class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.string :event_type, null: false
      t.text :description, null: false
      t.datetime :starts_at, null: false
      t.string :location, null: false
      t.references :place, foreign_key: true

      t.timestamps
    end
  end
end
