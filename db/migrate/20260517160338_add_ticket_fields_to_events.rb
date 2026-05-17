class AddTicketFieldsToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :ticket_required, :boolean, null: false, default: false
    add_column :events, :ticket_price, :decimal, precision: 8, scale: 2
    add_column :events, :ticket_url, :string
  end
end
