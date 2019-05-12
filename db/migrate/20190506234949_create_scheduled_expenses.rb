class CreateScheduledExpenses < ActiveRecord::Migration[5.2]
  def change
    create_table :scheduled_expenses do |t|
      t.references :apartment, foreign_key: true
      t.references :payer, foreign_key: {to_table: :users}
      t.references :issuer, foreign_key: {to_table: :users}
      t.string :title
      t.integer :amount
      t.integer :day_of_month

      t.timestamps
    end
  end
end
