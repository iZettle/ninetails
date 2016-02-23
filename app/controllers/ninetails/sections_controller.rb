module Ninetails
  class SectionsController < ApplicationController

    def index
      sections = Dir.glob(Rails.root.join("app", "components", "section", "*.rb")).collect do |filename|
        Section.new_from_filename(filename).serialize
      end

      render json: { sections: sections }
    end

    def show
      render json: Section.new_from_name(params[:id]).serialize
    end

    def validate
      @section = Ninetails::PageSection.new section_params

      unless @section.valid?
        render status: :bad_request
      end
    end

    private

    def section_params
      params.require(:section).permit!
    end

  end
end
