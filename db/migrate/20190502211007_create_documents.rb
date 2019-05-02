class CreateDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :documents do |t|
      t.references :apartment, foreign_key: true
      t.references :expense, foreign_key: true
      t.string :title
      t.string :filename
      t.boolean :apartmentwide
      t.timestamp :upload_date

      t.timestamps
    end
  end
end
