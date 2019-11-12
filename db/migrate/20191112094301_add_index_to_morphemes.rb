class AddIndexToMorphemes < ActiveRecord::Migration[5.2]
  def change
    add_index :morphemes, :origin
    add_index :morphemes, :pos
    add_index :morphemes, :book_id
  end
end
