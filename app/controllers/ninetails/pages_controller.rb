module Ninetails
  class PagesController < ApplicationController

    def show
      @container = Page.find_and_load_revision params, @project

      render "/ninetails/containers/show"
    end

  end
end
