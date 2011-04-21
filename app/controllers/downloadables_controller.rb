class DownloadablesController < ApplicationController
  respond_to :json

  def index
    respond_with Downloadable.all
  end
  
  def unconfirmed
    respond_with Downloadable.unconfirmed
  end

  def show
    respond_with Downloadable.find(params[:id])
  end
end
