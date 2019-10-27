class CreateArts < ActiveRecord::Migration[5.2]
  def change
    create_table :arts do |t|
      t.integer :mining_data_id
      t.string :mining_image

      t.timestamps
    end
  end
end
