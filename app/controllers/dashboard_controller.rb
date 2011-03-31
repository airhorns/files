class DashboardController < ApplicationController
  before_filter :authenticate_user!  
  def index
  end

  def secret_message
    SystemValue["footer_message"] = params[:message]
    render :nothing => true
  end
end
