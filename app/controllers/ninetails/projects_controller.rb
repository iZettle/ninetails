module Ninetails
  class ProjectsController < NinetailsController

    before_action :find_project, only: [:update, :destroy, :publish]

    def index
      @projects = Project.all
    end

    def show
      @project = Project.find params[:id]
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
      if @project.update_attributes project_params
        render :show, status: :ok
      else
        render :show, status: :bad_request
      end
    end

    def destroy
      @project.destroy
      head :no_content
    end

    def publish
      @project.publish!
      render :show
    end

    private

    def find_project
      @project = Project.find params[:id]
    end

    def project_params
      params.require(:project).permit(:name, :description)
    end

  end
end
