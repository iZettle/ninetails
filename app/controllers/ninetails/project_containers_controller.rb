module Ninetails
  class ProjectContainersController < NinetailsController

    def projects
      @project_containers = ProjectContainer.where(container_id: params[:container_id])
    end

  end
end
