class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.references :user, foreign_key: true
      t.references :apartment, foreign_key: true
      t.string :name
      t.boolean :bought
      t.string :description

      t.timestamps
    end
  end
end
