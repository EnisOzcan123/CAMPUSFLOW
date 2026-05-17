class AddPaymentFieldsToTickets < ActiveRecord::Migration[7.1]
  def change
    add_column :tickets, :card_holder_name, :string
    add_column :tickets, :card_last_four, :string
    add_column :tickets, :payer_iban, :string
  end
end
