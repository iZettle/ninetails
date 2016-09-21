module Ninetails
  class ContainersController < NinetailsController

    def index
      if project.present?
        @containers = project.public_send params[:type]
      else
        @containers = container_class.all
      end
    end

    def show
      @container = container_class.find_and_load_revision params, project
    end

    def create
      @container = container_class.new container_params
      @container.created_in_project = project if project.present?

      if @container.save
        project.project_containers.create container: @container if project.present?

        render :show, status: :created
      else
        render :show, status: :bad_request
      end
    end

    private

    def container_params
      params.require(:container).permit(:url, :name, :locale, :layout_id)
    end

    def container_class
      if params[:type] == "layouts"
        Layout
      else
        Page
      end
    end

  end
end
