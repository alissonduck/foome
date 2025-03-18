class CitiesController < ApplicationController
  # GET /cities
  def index
    @cities = CityService.list_cities(params[:state_id])

    respond_to do |format|
      format.html
      format.json { render json: @cities }
    end
  end

  # GET /cities/:id
  def show
    @city = CityService.find_city(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @city }
    end
  end

  # GET /cities/search
  def search
    @cities = CityService.search_cities(params[:query])

    respond_to do |format|
      format.html { render :index }
      format.json { render json: @cities.as_json(include: :state) }
    end
  end
end
