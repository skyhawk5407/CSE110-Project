class CreateSessions < ActiveRecord::Migration[5.2]
  def change
    create_table :sessions do |t|
      t.string :identifier
      t.references :user, foreign_key: true
      t.timestamp :expiry

      t.timestamps
    end
  end
end
