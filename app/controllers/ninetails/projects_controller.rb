module Ninetails
  class ProjectsController < ApplicationController

    def index
      @projects = Project.all
    end

    def create
      @project = Project.new project_params

      if @project.save
        render :show, status: :created
      else
        render :show, status: :bad_request
      end
    end

    def update
      @project = Project.find params[:id]

      if @project.update_attributes project_params
        render :show, status: :ok
      else
        render :show, status: :bad_request
      end
    end

    private

    def project_params
      params.require(:project).permit(:name, :description)
    end

  end
end
