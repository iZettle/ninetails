module Ninetails
  class ContainersController < ApplicationController

    before_action :find_project_scope

    def index
      if @project.present?
        @containers = @project.containers
      else
        @containers = Container.all
      end
    end

    def show
      @container = Container.find params[:id]

      if params[:revision_id].present?
        @container.revision = @container.revisions.find params[:revision_id]
      elsif @project.present?
        @container.load_revision_from_project @project
      end
    end

    def create
      @container = Container.new container_params

      if @container.save
        @project.project_containers.create container: @container if @project.present?

        render :show, status: :created
      else
        render :show, status: :bad_request
      end
    end

    private

    def container_params
      params.require(:container).permit(:url, :name, :type)
    end

    def find_project_scope
      @project = Project.find params[:project_id] if params[:project_id]
    end

  end
end