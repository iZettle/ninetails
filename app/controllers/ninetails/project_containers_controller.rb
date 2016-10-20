module Ninetails
  class ProjectContainersController < NinetailsController

    def index
      if params[:container_id].present?
        @project_containers = ProjectContainer.where(container_id: params[:container_id])
      end
    end

  end
end
