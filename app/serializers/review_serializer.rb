# == Schema Information
#
# Table name: reviews
#
#  id              :bigint           not null, primary key
#  description     :text
#  rating          :integer
#  reviewable_type :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  reviewable_id   :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_reviews_on_reviewable  (reviewable_type,reviewable_id)
#  index_reviews_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class ReviewSerializer < ActiveModel::Serializer
    attributes :id, :created_at, :description, :rating
    attribute :user_id, key: :reviewer_id  
end
