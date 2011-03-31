class FilesController < ApplicationController
  respond_to :json
  
  # List info about one file
  def get
    filename = File.join(Files::Config.files_path, params[:path], '.', params[:ext])
    respond_with filename
  end

  # List files in a dir
  def index
    respond_with Dir.glob(File.join(Files::Config.files_path, params[:path] || "", "*"))
  end

end
