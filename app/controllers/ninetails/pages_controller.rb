module Ninetails
  class PagesController < ApplicationController

    def show
      @page = Page.find_by! url: params[:id]
      @page.revision = @page.revisions.find params[:revision_id] if params[:revision_id]

      render json: @page.to_builder.target!
    rescue ActiveRecord::RecordNotFound
      render json: {}, status: :not_found
    end

    def create
      @page = Page.new page_params

      if @page.save
        render json: @page.to_builder.target!, status: :created
      else
        render json: @page.to_builder.target!, status: :bad_request
      end
    end

    private

    def page_params
      params.require(:page).permit(:url, :name)
    end

  end
end
