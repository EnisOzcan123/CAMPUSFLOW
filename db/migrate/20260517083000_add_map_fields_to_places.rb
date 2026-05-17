class AddMapFieldsToPlaces < ActiveRecord::Migration[7.1]
  def change
    add_column :places, :location_label, :string
    add_column :places, :map_x, :integer
    add_column :places, :map_y, :integer
  end
end
