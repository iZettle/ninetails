module Ninetails
  class PagesController < ApplicationController

    def show
      @container = Page.find params[:id]

      render "/ninetails/containers/show"
    end

  end
end
