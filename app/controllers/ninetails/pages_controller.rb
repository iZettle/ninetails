module Ninetails
  class PagesController < ApplicationController

    def show
      @page = Page.find_by! url: params[:id]
      @page.revision = @page.revisions.find params[:revision_id] if params[:revision_id]

      render json: @page.to_builder.target!
    rescue ActiveRecord::RecordNotFound
      render json: {}, status: :not_found
    end

  end
end
