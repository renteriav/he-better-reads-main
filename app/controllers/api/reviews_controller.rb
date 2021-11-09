# frozen_string_literal: true

module API
    class ReviewsController < API::BaseController
        before_action :authenticate_user!, only: %i[create]
        before_action :find_parent, only: %i[create index]
        
        def create
            review = current_user.reviews.build(allowed_params)
            review.reviewable = @parent
        
            if review.save
                render json: review
            else
                render json: { errors: review.errors.full_messages }
            end
        end
    
        def index
            # fetch reviews for specific Author or Book then filter and sort
            # using model scopes according to params provided.
            # if params[:with_description] is not specified, it returns only reviews
            # with description. if param[:sort_by_rating] is not present, it sorts by
            # created_at: :desc.
            
            with_description = true
            with_description = false if params[:with_description_only] == 'false'

            reviews = @parent.reviews.order(created_at: :desc)
            reviews = reviews.with_rating(params[:rating]) if params[:rating]
            reviews = reviews.sort_by_rating(params[:sort_by_rating]) if ['asc', 'desc'].include?params[:sort_by_rating]
            reviews = reviews.with_description if with_description

            render json: reviews
        end
    
        def show
            render json: Review.find(params[:id])
        end
    
        private
    
        def allowed_params
            params.permit(
                :user_id,
                :description,
                :rating,
                :reviewable_type,
                :reviewable_id             
            )
        end

    end
end
