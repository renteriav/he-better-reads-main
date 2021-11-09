class AddCounterCacheToAuthors < ActiveRecord::Migration[6.1]
  def change
    add_column :authors, :reviews_count, :integer
  end
end
