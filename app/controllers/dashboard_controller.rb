class DashboardController < ApplicationController
  before_filter :authenticate_user!  
  respond_to :html

  def index
  end
  
  def stream
    @downloadable = Downloadable.find(params[:id])
    if params[:release]
      @release = @downloadable.releases[params[:release]]
    else
      @release = @downloadable.releases.first
    end
    respond_with @downloadable
  end

  def download
    @downloadable = Downloadable.find(params[:id])
    respond_with @downloadable
  end

  def secret_message
    SystemValue["footer_message"] = params[:message]
    render :nothing => true
  end
end
