module Ninetails
  class NinetailsController < ActionController::API
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
