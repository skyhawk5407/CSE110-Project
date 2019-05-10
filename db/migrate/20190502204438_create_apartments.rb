class CreateApartments < ActiveRecord::Migration[5.2]
  def change
    create_table :apartments do |t|
      t.string :address, null: false
      t.string :name, null: false
      t.references :user, foreign_key: true, null: false
      t.string :items
      t.string :access_code, null: false
      t.timestamps
    end
  end
end
