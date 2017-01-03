module Ninetails
  class FoldersController < NinetailsController

    before_action :find_folder, only: [:update, :destroy]

    def index
      @folders = Folder.all
    end

    def create
      @folder = Folder.new folder_params

      if @folder.save
        render :show, status: :created
      else
        render :show, status: :bad_request
      end
    end

    def update
      if @folder.update_attributes folder_params
        render :show, status: :created
      else
        render :show, status: :bad_request
      end
    end

    def destroy
      @folder.delete
      head :no_content
    end

    private

    def find_folder
      @folder = Folder.find params[:id]
    end

    def folder_params
      params.require(:folder).permit(:name)
    end

  end
end
