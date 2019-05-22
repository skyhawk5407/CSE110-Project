class CreateDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :documents do |t|
      t.references :apartment, foreign_key: true, null: false
      t.references :expense, foreign_key: true
      t.string :title, null: false
      t.string :filename, null: false
      t.boolean :apartmentwide

      t.timestamps
    end
  end
end
