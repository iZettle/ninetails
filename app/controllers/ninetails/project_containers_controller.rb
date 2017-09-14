module Ninetails
  class ProjectContainersController < NinetailsController

    def projects
      @project_containers = ProjectContainer.eager_load(:project).where(container_id: params[:container_id], "ninetails_projects.published": false)
    end

  end
end
