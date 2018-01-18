module Ninetails
  class SectionsController < NinetailsController

    def index
      sections_path = Rails.root.join(Ninetails::Config.components_directory, "section", "*.rb")
      sections = Dir.glob(sections_path).collect do |filename|
        Section.new_from_filename(filename).serialize
      end

      render json: { sections: sections }
    end

    def show
      render json: Section.new_from_name(params[:id]).serialize
    end

    def validate
      @section = Ninetails::ContentSection.new section_params

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
