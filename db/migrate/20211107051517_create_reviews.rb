class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.text :description
      t.integer :rating
      t.references :user, null: false, foreign_key: true
      t.references :reviewable, polymorphic: true, null: false, index: true

      t.timestamps
    end
  end
end
