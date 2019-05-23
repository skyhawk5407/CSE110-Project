class CreateExpenses < ActiveRecord::Migration[5.2]
  def change
    create_table :expenses do |t|
      t.references :apartment, foreign_key: true, null: false
      t.references :payer, foreign_key: {to_table: :users}, null: false
      t.references :issuer, foreign_key: {to_table: :users}, null: false
      t.string :title, null: false
      t.integer :amount, null: false
      t.boolean :paid
      t.timestamp :paid_date

      t.timestamps
    end
  end
end
