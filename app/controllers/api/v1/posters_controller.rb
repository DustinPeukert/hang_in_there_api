class Api::V1::PostersController < ApplicationController
  def index
    posters = Poster.all

    if params[:name].present?
      posters = posters.where("name ILIKE ?", "%#{params[:name]}%")
      posters = posters.order(:name)
    end

    if params[:max_price].present?
      posters = posters.where('price <= ?' ,params[:max_price].to_f)
    end

    if params[:min_price].present?
      posters = posters.where('price >= ?' ,params[:min_price].to_f)
    end

    if params[:sort] == 'asc'
      posters = posters.order(:created_at)
    elsif params[:sort] == 'desc'
      posters = posters.order(created_at: :desc)
    end

    render json: PosterSerializer.new(posters, meta: { count: posters.count })
  end

  def show
    poster = Poster.find(params[:id])
    render json: PosterSerializer.new(poster)
  end

  def create
    poster = Poster.create(poster_params)
    render json: PosterSerializer.new(poster)
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