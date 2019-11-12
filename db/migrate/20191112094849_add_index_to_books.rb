class AddIndexToBooks < ActiveRecord::Migration[5.2]
  def change
    add_index :books, :user_id
    add_index :books, :title
    add_index :books, :body
  end
end
