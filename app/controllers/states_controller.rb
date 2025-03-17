class StatesController < ApplicationController
  # GET /states
  def index
    @states = State.all.order(:name)

    respond_to do |format|
      format.html
      format.json { render json: @states }
    end
  end

  # GET /states/:id
  def show
    @state = State.find(params[:id])
    @cities = @state.cities.order(:name)

    respond_to do |format|
      format.html
      format.json { render json: { state: @state, cities: @cities } }
    end
  end

  # GET /states/by_abbreviation/:abbreviation
  def by_abbreviation
    @state = State.find_by!(abbreviation: params[:abbreviation].upcase)
    @cities = @state.cities.order(:name)

    respond_to do |format|
      format.html { render :show }
      format.json { render json: { state: @state, cities: @cities } }
    end
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to states_path, alert: "Estado não encontrado." }
      format.json { render json: { error: "Estado não encontrado" }, status: :not_found }
    end
  end
end
