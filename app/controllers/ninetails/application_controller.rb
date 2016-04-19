module Ninetails
  class ApplicationController < ActionController::API
    include ActionController::ImplicitRender

    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    before_action :find_project_scope

    def not_found
      render json: {}, status: :not_found
    end

    private

    def find_project_scope
      @project = Project.find params[:project_id] if params[:project_id]
    end

  end
end
