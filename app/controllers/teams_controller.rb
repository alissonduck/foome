class TeamsController < ApplicationController
  before_action :set_team, only: %i[ show edit update destroy ]

  # GET /teams or /teams.json
  def index
    @teams = TeamService.list_teams
  end

  # GET /teams/1 or /teams/1.json
  def show
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams or /teams.json
  def create
    result = TeamService.create_team(team_params)
    @team = result[:team]

    respond_to do |format|
      if result[:success]
        format.html { redirect_to @team, notice: "Equipe criada com sucesso." }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teams/1 or /teams/1.json
  def update
    result = TeamService.update_team(@team, team_params)

    respond_to do |format|
      if result[:success]
        format.html { redirect_to @team, notice: "Equipe atualizada com sucesso." }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1 or /teams/1.json
  def destroy
    result = TeamService.destroy_team(@team)

    respond_to do |format|
      if result[:success]
        format.html { redirect_to teams_path, status: :see_other, notice: "Equipe removida com sucesso." }
        format.json { head :no_content }
      else
        format.html { redirect_to @team, alert: "Erro ao remover equipe: #{ErrorHandlerService.format_operation_errors(result)}" }
        format.json { render json: result[:errors], status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = TeamService.find_team(params[:id])
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.html { redirect_to teams_path, alert: "Equipe não encontrada." }
        format.json { render json: { error: "Equipe não encontrada" }, status: :not_found }
      end
    end

    # Only allow a list of trusted parameters through.
    def team_params
      params.require(:team).permit(:company_id, :name, :manager_id, :active)
    end
end
