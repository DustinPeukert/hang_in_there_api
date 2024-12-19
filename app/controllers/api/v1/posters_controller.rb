class Api::V1::PostersController < ApplicationController
  def index
    posters = Poster.all
    render json: PosterSerializer.new(posters)
  end

  def update
    poster = Poster.update(params[:id], poster_params)
    render json: PosterSerializer.new(poster)
  end

  def poster_params
    params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url)
  end
end