class Api::V1::PostersController < ApplicationController
  def index
    posters = Poster.all

    if params[:sort] == 'asc'
      posters = posters.order(:created_at)
    elsif params[:sort] == 'desc'
      posters = posters.order(created_at: :desc)
    end

    render json: PosterSerializer.new(posters, meta: { count: posters.count })
  end

  def update
    poster = Poster.update(params[:id], poster_params)
    render json: PosterSerializer.new(poster)
  end

  def destroy
    poster = Poster.find(params[:id])
    
    if poster
      poster.destroy
      head :no_content #semantic version of 204
    end
  end

  private

  def poster_params
    params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url)
  end
end