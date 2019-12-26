class AddSentimentToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :sentiment, :float
    add_column :books, :colors, :string
  end
end
