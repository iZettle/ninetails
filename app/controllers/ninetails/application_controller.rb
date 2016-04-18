module Ninetails
  class ApplicationController < ActionController::API
    include ActionController::ImplicitRender

    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    def not_found
      render json: {}, status: :not_found
    end

  end
end
