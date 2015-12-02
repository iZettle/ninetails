module Ninetails
  class SectionsController < ApplicationController

    def index
      sections = Rails.root.join("app", "components", "section").children.collect do |entry|
        empty_section_from_name entry.basename.to_s.sub(/(\..*)$/, '')
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
