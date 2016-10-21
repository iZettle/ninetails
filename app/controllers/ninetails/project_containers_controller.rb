module Ninetails
  class ProjectContainersController < NinetailsController

    def projects
      @project_containers = ProjectContainer.includes(:project).where container_id: params[:container_id]
    end

  end
end
