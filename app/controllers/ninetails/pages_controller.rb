module Ninetails
  class PagesController < ApplicationController

    before_action :find_project_scope

    def index
      if @project.present?
        @pages = @project.pages
      else
        @pages = Page.all
      end
    end

    def show
      if params[:id] =~ /^\d+$/
        @page = Page.find params[:id]
      else
        @page = Page.find_by! url: params[:id]
      end

      if params[:revision_id].present?
        @page.revision = @page.revisions.find params[:revision_id]
      elsif @project.present?
        @page.revision = @project.project_pages.find_by(page_id: params[:id]).page_revision
      end

    rescue ActiveRecord::RecordNotFound
      render json: {}, status: :not_found
    end

    def create
      @page = Page.new page_params

      if @page.save
        @project.project_pages.create page: @page if @project.present?

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

  end
end
