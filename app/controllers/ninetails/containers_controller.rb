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
      if params[:id] =~ /^\d+$/
        @container = Container.find params[:id]
      else
        @container = Container.find_by! url: params[:id]
      end

      if params[:revision_id].present?
        @container.revision = @container.revisions.find params[:revision_id]
      elsif @project.present?
        project_container = @project.project_containers.find_by container_id: params[:id]
        @container.revision = project_container.revision if project_container.present?
      end

    rescue ActiveRecord::RecordNotFound
      render json: {}, status: :not_found
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
      params.require(:container).permit(:url, :name)
    end

    def find_project_scope
      @project = Project.find params[:project_id] if params[:project_id]
    rescue ActiveRecord::RecordNotFound
      render json: {}, status: :not_found
    end

  end
end
