class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.references :user, index: true, foreign_key: true
      t.references :apartment, index: true, foreign_key: true, null: false
      t.string :name, null: false
      t.boolean :bought
      t.string :description, null: false

      t.timestamps
    end
  end
end
