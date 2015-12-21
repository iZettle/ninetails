module Ninetails
  class PagesController < ApplicationController

    def index
      @pages = Page.all
    end

    def show
      @page = Page.find_by! url: params[:id]
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

  end
end
