# frozen_string_literal: true

# == Schema Information
#
# Table name: authors
#
#  id             :bigint           not null, primary key
#  average_rating :float
#  description    :text
#  first_name     :string
#  genres         :string           default([]), is an Array
#  last_name      :string
#  reviews_count  :integer
#  website        :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Author < ApplicationRecord
  validates :description, presence: true

  has_many :books, dependent: :destroy
  has_many :reviews, as: :reviewable
end
