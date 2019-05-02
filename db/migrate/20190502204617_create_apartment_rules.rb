class CreateApartmentRules < ActiveRecord::Migration[5.2]
  def change
    create_table :apartment_rules do |t|
      t.references :apartment, foreign_key: true
      t.string :rule

      t.timestamps
    end
  end
end
