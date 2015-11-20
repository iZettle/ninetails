module Ninetails
  class SectionsController < ApplicationController

    def index
      sections = Rails.root.join("app", "components", "section").children.collect do |entry|
        entry.basename.to_s.sub(/(\..*)$/, '').classify
      end

      render json: { sections: sections }
    end

    def show
      render json: "Section::#{params[:id]}".safe_constantize.new.serialize
    end

  end
end
