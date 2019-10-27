class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.integer  :user_id
      t.string :title
      t.text :body

      t.timestamps
    end
    add_column :books, :deleted_at, :datetime #論理削除用追記
    add_index :books, :deleted_at #論理削除用追記
  end
end
