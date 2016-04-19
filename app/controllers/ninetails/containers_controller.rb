module Ninetails
  class ContainersController < ApplicationController

    def index
      if @project.present?
        @containers = @project.pages
      else
        @containers = Page.all
      end
    end

    def show
      @container = Page.find_and_load_revision params, @project
    end

    def create
      @container = Page.new container_params

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

  end
end
