module Ninetails
  class SectionTemplatesController < ApplicationController

    def index
      templates = Rails.root.join("app", "components", "section_template").children.collect do |entry|
        entry.basename.to_s.sub(/(\..*)$/, '').classify
      end

      render json: { templates: templates }
    end

    def show
      render json: "SectionTemplate::#{params[:id]}".safe_constantize.new.serialize
    end

  end
end
