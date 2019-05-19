class CreateApartments < ActiveRecord::Migration[5.2]
  def change
    create_table :apartments do |t|
      t.string :address, null: false
      t.string :name, null: false
      t.string :access_code, index:{unique: true}, null: false
      t.timestamps
    end
  end
end
