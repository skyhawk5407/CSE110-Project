class CreateUnreadNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :unread_notifications do |t|
      t.references :user, foreign_key: true
      t.references :notification, foreign_key: true

      t.timestamps
    end
  end
end
