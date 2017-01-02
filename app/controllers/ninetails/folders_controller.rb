module Ninetails
  class FoldersController < NinetailsController

    def index
      @folders = Folder.all
    end

  end
end
