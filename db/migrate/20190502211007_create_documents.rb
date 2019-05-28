class CreateDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :documents do |t|
      t.belongs_to :apartment, index: true, foreign_key: true, null: false
      t.belongs_to :expense, index: {unique: true}, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true, null: false
      t.string :title, null: false
      t.boolean :apartmentwide, null: false

      t.timestamps
    end
  end
end
