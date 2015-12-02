module Ninetails
  class SectionsController < ApplicationController

    def index
      sections = Dir.glob(Rails.root.join("app", "components", "section", "*.rb")).collect do |entry|
        empty_section_from_name File.basename(entry, ".rb")
      end

      render json: { sections: sections }
    end

    def show
      render json: empty_section_from_name(params[:id])
    end

    private

    def empty_section_from_name(id)
      "Section::#{id.classify}".safe_constantize.new.serialize
    end

  end
end
