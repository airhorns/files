class DashboardController < ApplicationController
  before_filter :authenticate_user!  
  respond_to :html

  def index
  end
  
  def stream
    @downloadable = Downloadable.get!(params[:id])
    respond_with @downloadable
  end

  def download
    @downloadable = Downloadable.get!(params[:id])
    respond_with @downloadable
  end

  def secret_message
    SystemValue["footer_message"] = params[:message]
    render :nothing => true
  end
end
