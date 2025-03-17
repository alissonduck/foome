class CitiesController < ApplicationController
  # GET /cities
  def index
    @cities = if params[:state_id].present?
                City.where(state_id: params[:state_id]).order(:name)
    else
                City.all.includes(:state).order(:name)
    end

    respond_to do |format|
      format.html
      format.json { render json: @cities }
    end
  end

  # GET /cities/:id
  def show
    @city = City.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @city }
    end
  end

  # GET /cities/search
  def search
    query = params[:query].to_s.downcase
    @cities = City.where("LOWER(name) LIKE ?", "%#{query}%")
                  .includes(:state)
                  .order(:name)
                  .limit(10)

    respond_to do |format|
      format.html { render :index }
      format.json { render json: @cities.as_json(include: :state) }
    end
  end
end
