class StatesController < ApplicationController
  # GET /states
  def index
    @states = StateService.list_states

    respond_to do |format|
      format.html
      format.json { render json: @states }
    end
  end

  # GET /states/:id
  def show
    @state = StateService.find_state(params[:id])
    @cities = StateService.cities_for_state(@state)

    respond_to do |format|
      format.html
      format.json { render json: { state: @state, cities: @cities } }
    end
  end

  # GET /states/by_abbreviation/:abbreviation
  def by_abbreviation
    begin
      @state = StateService.find_by_abbreviation(params[:abbreviation])
      @cities = StateService.cities_for_state(@state)

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
end
