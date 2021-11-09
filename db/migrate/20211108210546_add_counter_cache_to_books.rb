class AddCounterCacheToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :reviews_count, :integer
  end
end
