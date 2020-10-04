class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.text :username, null: false
      t.text :password_digest, null: false

      t.timestamps

      t.index :username
    end
  end
end
