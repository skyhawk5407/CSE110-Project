class CreateApartmentMates < ActiveRecord::Migration[5.2]
  def change
    create_table :apartment_mates do |t|
      t.references :user, foreign_key: true
      t.references :apartment, foreign_key: true

      t.timestamps
    end
  end
end
