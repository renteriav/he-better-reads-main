class AddAverageRatingToAuthors < ActiveRecord::Migration[6.1]
  def change
    add_column :authors, :average_rating, :float
  end
end
