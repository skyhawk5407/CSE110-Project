class CreateRules < ActiveRecord::Migration[5.2]
  def change
    create_table :rules do |t|
      t.references :apartment, foreign_key: true
      t.string :rule

      t.timestamps
    end
  end
end
