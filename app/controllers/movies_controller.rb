class MoviesController < ApplicationController
  respond_to :json

  def index
    respond_with Movie.all
  end

  def show
    respond_with Movie.get(params[:id])
  end

  def update
  end
end
