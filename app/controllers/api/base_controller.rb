class API::BaseController < ApplicationController

    rescue_from(ActionController::ParameterMissing) do |parameter_missing_exception|
      error = ["Missing parameter: #{parameter_missing_exception.param}"]
      response = { errors: error }
      render json: response, status: :unprocessable_entity
    end

    def find_parent
      # finds parent in polymorphic association
      resource, id = request.path.split('/')[2, 3]
      model = resource.singularize.classify.constantize
      @parent = model.find(id)
    rescue
      error = ["#{model} with provided id could not be found"]
      response = { errors: error }
      render json: response, status: :not_found
    end
  
end