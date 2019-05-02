class CreateApartments < ActiveRecord::Migration[5.2]
  def change
    create_table :apartments do |t|
      t.string :address
      t.string :name
      t.references :user, foreign_key: true
      t.string :items
      t.string :access_code
      t.timestamps
    end
  end
end
