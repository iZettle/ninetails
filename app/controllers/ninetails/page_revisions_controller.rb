module Ninetails
  class PageRevisionsController < ApplicationController

    before_action :find_page

    def index
    end

    def create
      @page.build_revision_from_params revision_params

      if @page.revision.save
        render "/ninetails/pages/show", status: :created
      else
        render "/ninetails/pages/show", status: :bad_request
      end
    end

    private

    def find_page
      @page = Page.find params[:page_id]
    end

    def revision_params
      params.require(:page_revision).permit!
    end

  end
end
