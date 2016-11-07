module Ninetails
  class ContainersController < NinetailsController

    def index
      if project.present?
        @containers = project.project_containers.of_type container_class.name
      else
        @containers = container_class.all.includes :current_revision
      end
    end

    def show
      @container = container_class.find_and_load_revision params, project
    end

    def create
      @container = container_class.new container_params

      if @container.save
        project.project_containers.create container: @container if project.present?

        render :show, status: :created
      else
        render :show, status: :bad_request
      end
    end

    def destroy
      container_class.find(params[:id]).destroy

      head :no_content
    end

    private

    def container_params
      params.require(:container).permit(:name, :locale, :layout_id)
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
