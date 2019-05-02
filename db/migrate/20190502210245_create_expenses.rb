class CreateExpenses < ActiveRecord::Migration[5.2]
  def change
    create_table :expenses do |t|
      t.references :apartment, foreign_key: true
      t.references :payer, foreign_key: {to_table: :users}
      t.references :issuer, foreign_key: {to_table: :users}
      t.integer :amount
      t.boolean :paid
      t.boolean :verified
      t.timestamp :verified_date
      
      t.timestamps
    end
  end
end
