class CreateTickets < ActiveRecord::Migration[7.1]
  def change
    create_table :tickets do |t|
      t.references :event, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 1
      t.decimal :total_price, precision: 8, scale: 2, null: false, default: 0
      t.string :status, null: false, default: "confirmed"

      t.timestamps
    end
  end
end
