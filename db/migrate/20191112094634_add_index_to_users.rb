class AddIndexToUsers < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :user_name
    add_index :users, :email
  end
end
