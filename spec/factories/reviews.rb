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
FactoryBot.define do
  factory :review do
    description { Faker::Lorem.paragraph }
    rating { 2 }
    user { nil }
    reviewable { nil }

    trait :without_description do
      description { nil }
    end

    trait :rating_1 do
      rating { 1 }
    end

    trait :rating_5 do
      rating { 5 }
    end
  end

end
