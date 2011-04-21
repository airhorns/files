class ReleasesController < ApplicationController
  respond_to :json

  before_filter do
    @downloadable = Downloadable.find(params[:downloadable_id])
  end

  def index
    respond_with @downloadable.releases
  end
  
  def unconfirmed
    respond_with @downloadable.releases.where(:confirmed => false)
  end

  def show
    respond_with @downloadable.releases.find(params[:id])
  end
end
