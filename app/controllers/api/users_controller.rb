# frozen_string_literal: true

module API
  class UsersController < ApplicationController

    def index
      render json: User.all
    end

    def show
      render json: User.find(params[:id])
    end

    def update
      user = User.find(params[:id])

      if user.update(allowed_params)
        render json: user
      else
        render json: { errors: user.errors.full_messages }
      end
    end

    private

    def allowed_params
      params.permit(
        :email,
        :password,
        :first_name,
        :last_name
      )
    end
  end
end
