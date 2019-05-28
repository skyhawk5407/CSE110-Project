class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.references :apartment, index: true, foreign_key: true, null: false
      t.references :user, index: true, foreign_key: true
      t.string :title, null: false
      t.string :message, null: false

      t.timestamps
    end
    add_index :notifications, :created_at
  end
end
