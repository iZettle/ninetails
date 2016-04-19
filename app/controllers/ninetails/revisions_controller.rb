module Ninetails
  class RevisionsController < ApplicationController

    before_action :find_container

    def index
    end

    def create
      @container.build_revision_from_params revision_params

      if @container.revision.save
        render "/ninetails/containers/show", status: :created
      else
        render "/ninetails/containers/show", status: :bad_request
      end
    end

    private

    def find_container
      @container = Container.find params[:page_id]
    end

    def revision_params
      params.require(:revision).permit!
    end

  end
end
