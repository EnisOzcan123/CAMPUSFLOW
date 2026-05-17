class CreatePlaces < ActiveRecord::Migration[7.1]
  def change
    create_table :places do |t|
      t.string :name
      t.string :category
      t.text :description
      t.integer :wifi_score
      t.integer :quiet_score

      t.timestamps
    end
  end
end
