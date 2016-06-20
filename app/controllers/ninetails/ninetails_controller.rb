module Ninetails
  class NinetailsController < ActionController::API

    # If the parent ApplicationController is an `ActionController::API` controller,
    # it will not have the renderer, so we include it just to be sure.
    include ActionController::ImplicitRender

    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    def not_found
      render json: {}, status: :not_found
    end

    def project
      @project ||= Project.find params[:project_id] if params[:project_id]
    end

  end
end
