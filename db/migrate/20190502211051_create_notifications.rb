class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.references :apartment, foreign_key: true
      t.references :user, foreign_key: true
      t.string :message
      t.timestamp :sent_date

      t.timestamps
    end
  end
end
