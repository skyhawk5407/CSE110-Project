class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, index: {unique: true}, null: false
      t.references :apartment, foreign_key: true, index: {unique: false}, on_delete: :nullify
      t.string :password_digest, null: false
      t.string :reset_token, index:{unique: true}, null: false
      t.string :display_name, null: false

      t.timestamps
    end
  end
end
