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
class Review < ApplicationRecord
  include Calculations
  belongs_to :user
  belongs_to :reviewable, polymorphic: true, counter_cache: true

  validate :clean_text
  validates :user_id, :uniqueness => { 
    :scope => [:reviewable_type, :reviewable_id],
    :message => 'already submitted a review for this Book or Author'
  }
  validates :rating, :reviewable_type, :reviewable_id, presence: true
  validates :rating, numericality: { greater_than_or_equal_to: 1,
                                    less_than_or_equal_to: 5,
                                    only_integer: true }

  scope :with_rating, ->(rating) { where(rating: rating) }
  scope :sort_by_rating, ->(order='desc') { reorder(:rating => order) }
  scope :with_description_only, -> { where("description <> ''") }

  after_save :update_average
  after_destroy :update_average

  private

  def update_average
    average = Calculations.calculate_average(reviewable, 'reviews', 'rating')
    reviewable.update_attribute :average_rating, average
  end

  def clean_text
    if description.present?
      text = description.dup
      text.downcase!

      banned_words = BANNED_WORDS
      banned_words.each do |word|  
        if text.include? word
            errors['description'] << 'contains profanity'
            break
        end
      end
    end
  end
    

end
