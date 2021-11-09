# frozen_string_literal: true

RSpec.describe '/api/reviews' do
    let(:response_hash) { JSON(response.body, symbolize_names: true) }
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:book) { create(:book) }
    let(:author) { create(:author) }
  
    describe 'GET to /books/:id' do
        before do
            @review = build(:review, :rating_1)
            @review.user = user
            @review.reviewable = book
            @review.save
        end
        context 'without parameters' do
            it 'returns all reviews for a book with params[:id]' do
                get api_book_reviews_path(book.id)

                expect(response_hash).to eq(
                    [
                        {
                            id: @review.id,
                            created_at: @review.created_at.iso8601(3),
                            description: @review.description,
                            rating: @review.rating,
                            reviewer_id: @review.user_id
                        }
                    ]
                )
            end

            it 'shows only reviews with a description' do
                review2 = build(:review, :without_description)
                review2.user = user2
                review2.reviewable = book
                review2.save
                review_count = Review.where(reviewable_type: 'Book',
                    reviewable_id: book.id).count

                get api_book_reviews_path(book.id)
                
                expect(response_hash.count).to eq(review_count - 1)
                expect(response_hash.first[:description]).to eq(@review.description)
            end

            it 'orders by created_at: :desc' do
                review2 = build(:review)
                review2.user = user2
                review2.reviewable = book
                review2.save

                get api_book_reviews_path(book.id)

                expect(response_hash.first[:created_at]).to be > (
                    response_hash.last[:created_at]
                )
            end
        end

        context 'with params[:rating]' do
            it 'filters by rating' do
                review2 = build(:review, :rating_5)
                review2.user = user2
                review2.reviewable = book
                review2.save
                review_count = book.reviews.count

                get api_book_reviews_path(book.id, rating: 1)
                
                expect(response_hash.count).to eq(review_count - 1)
                expect(response_hash.first[:rating]).to eq(1)
            end
        end

        context 'with params[:sort_by_rating]' do
            before do
                @review2 = build(:review, :rating_5)
                @review2.user = user2
                @review2.reviewable = book
                @review2.save
            end
            it 'when `asc` filters reviews by rating: :asc' do  
                get api_book_reviews_path(book.id, sort_by_rating: 'asc')
                expect(response_hash.first[:rating]).to be <(
                    response_hash.last[:rating]
                )
            end

            it 'when `desc` filters reviews by rating: :desc' do  
                get api_book_reviews_path(book.id, sort_by_rating: 'desc')
                expect(response_hash.first[:rating]).to be >(
                    response_hash.last[:rating]
                )
            end
        end

        context 'with params[:with_description_only]' do
            it 'when false it fetches all reviews for that book' do
                review2 = build(:review, :without_description)
                review2.user = user2
                review2.reviewable = book
                review2.save
                review_count = Review.where(reviewable_type: 'Book',
                    reviewable_id: book.id).count

                get api_book_reviews_path(book.id, with_description_only: false)
                
                expect(response_hash.count).to eq(review_count)
                expect(response_hash.count).to be > (1)
            end
        end
    end
  
    describe 'GET to /:id' do
        before do
            @review = build(:review)
            @review.user = user
            @review.reviewable = book
            @review.save
        end
        context 'when found' do
            it 'returns a review' do

                get api_book_review_path book, @review

                expect(response_hash).to eq(
                    {
                        id: @review.id,
                        created_at: @review.created_at.iso8601(3),
                        description: @review.description,
                        rating: @review.rating,
                        reviewer_id: @review.user_id
                    }
                )
            end
        end
  
        context 'when not found' do
            it 'returns not_found' do
                get api_book_review_path(book, -1)
        
                expect(response).to be_not_found
            end
        end
    end
    
    describe 'POST to /' do
        before do
            login_with_api(user)
            @headers = {'Authorization': response.headers['Authorization']}
        end
        context 'when successful' do
            let(:params) do
            {
                rating: 5
            }
            end

            it 'creates a review without a description' do
                expect { post api_book_reviews_path(book), params: params, headers: @headers }.to change(Review, :count)
            end

            it 'returns the created review' do
                post api_book_reviews_path(book), params: params, headers: @headers
                expect(response_hash).to include(params)
            end

            it 'updates the average rating' do
                # create a review for the book with rating 5
                review = build(:review, :rating_5)
                review.user = user
                review.reviewable = book
                review.save
                
                review2 = build(:review, :rating_1)
                review2.user = user2
                review2.reviewable = book
                review2.save
                review2.run_callbacks :save
                
                expect(book.reload.average_rating.to_s).to eq('3.0')
            end
        end

        context 'when unsuccessful' do
            let(:params) do
                { description: 'It was a good book' }
            end

            it 'returns unauthorized when Authorization header is missing' do
                post api_book_reviews_path(book), params: params
                expect(response).to be_unauthorized
            end

            it 'returns an error when rating is missing' do
                post api_book_reviews_path(book), params: params, headers: @headers
                expect(response_hash[:errors]).to include('Rating is required')
            end

            it 'returns an error when rating is not an integer' do
                post api_book_reviews_path(book), params: {rating: 4.3}, headers: @headers
                expect(response_hash[:errors]).to include('Rating must be an integer')
            end

            it 'returns an error when rating is greater than 5' do
                post api_book_reviews_path(book), params: {rating: 6}, headers: @headers
                expect(response_hash[:errors]).to include('Rating must be less than or equal to 5')
            end

            it 'returns an error when rating is less than 1' do
                post api_book_reviews_path(book), params: {rating: 0}, headers: @headers
                expect(response_hash[:errors]).to include('Rating must be greater than or equal to 1')
            end

            it 'returns an error when user submits a second review for same book' do
                post api_book_reviews_path(book), params: {rating: 4}, headers: @headers
                post api_book_reviews_path(book), params: {rating: 4}, headers: @headers
                expect(response_hash[:errors]).to include('User already submitted a review for this Book or Author')
            end

            it 'returns an error when description contains a banned word' do
                post api_book_reviews_path(book), params: {rating: 4, description: '-fRAk_'}, headers: @headers
                expect(response_hash[:errors]).to include('Description contains profanity')
            end
        end
    end
end  