# frozen_string_literal: true

# == Schema Information
#
# Table name: books
#
#  id             :bigint           not null, primary key
#  average_rating :float
#  description    :text             not null
#  publish_date   :date
#  rating         :decimal(, )
#  reviews_count  :integer
#  title          :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  author_id      :bigint
#
# Indexes
#
#  index_books_on_author_id  (author_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => authors.id)
#
class Book < ApplicationRecord
  belongs_to :author

  validates :title, :description, presence: true
  has_many :reviews, as: :reviewable
end
