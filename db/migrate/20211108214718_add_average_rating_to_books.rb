class AddAverageRatingToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :average_rating, :float
  end
end
