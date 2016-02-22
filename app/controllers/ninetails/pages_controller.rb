module Ninetails
  class PagesController < ApplicationController

    before_action :find_project_scope, only: :index
    before_action :find_page, only: :show

    def index
      if @project.present?
        @pages = Page.in_project(@project).all
      else
        @pages = Page.all
      end
    end

    def show
      @page.revision = @page.revisions.find params[:revision_id] if params[:revision_id]

    rescue ActiveRecord::RecordNotFound
      render json: {}, status: :not_found
    end

    def create
      @page = Page.new page_params

      if @page.save
        render :show, status: :created
      else
        render :show, status: :bad_request
      end
    end

    private

    def page_params
      params.require(:page).permit(:url, :name)
    end

    def find_project_scope
      @project = Project.find params[:project_id] if params[:project_id]
    rescue ActiveRecord::RecordNotFound
      render json: {}, status: :not_found
    end

    def find_page
      if params[:id] =~ /^\d+$/
        @page = Page.find params[:id]
      else
        @page = Page.find_by! url: params[:id]
      end
    rescue ActiveRecord::RecordNotFound
      render json: {}, status: :not_found
    end

  end
end
