class CreateMorphemes < ActiveRecord::Migration[5.2]
  def change
    create_table :morphemes do |t|
      t.string :surface
      t.string :reading
      t.string :origin
      t.string :pos
      t.string :inflection
      t.string :conjugation
      t.integer :book_id

      t.timestamps
    end
  end
end
