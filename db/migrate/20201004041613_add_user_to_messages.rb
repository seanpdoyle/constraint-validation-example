class AddUserToMessages < ActiveRecord::Migration[6.1]
  def change
    add_reference :messages, :user, null: false, foreign_key: true, index: true
  end
end
