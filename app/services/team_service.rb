# app/services/team_service.rb
class TeamService
  # Serviço responsável por gerenciar operações relacionadas a equipes
  # Encapsula a lógica de criação, atualização, busca e remoção de equipes

  # Lista todas as equipes
  # @return [ActiveRecord::Relation] Coleção de equipes
  def self.list_teams
    Team.all
  end

  # Busca uma equipe pelo ID
  # @param [Integer] id ID da equipe
  # @return [Team] Equipe encontrada
  # @raise [ActiveRecord::RecordNotFound] Caso a equipe não seja encontrada
  def self.find_team(id)
    Team.find(id)
  end

  # Cria uma nova equipe
  # @param [Hash] params Parâmetros para criação da equipe
  # @return [Hash] Resultado da operação com a equipe criada ou erros
  def self.create_team(params)
    team = Team.new(params)

    if team.save
      { success: true, team: team }
    else
      { success: false, errors: team.errors, team: team }
    end
  end

  # Atualiza uma equipe existente
  # @param [Team] team Equipe a ser atualizada
  # @param [Hash] params Parâmetros para atualização da equipe
  # @return [Hash] Resultado da operação com a equipe atualizada ou erros
  def self.update_team(team, params)
    if team.update(params)
      { success: true, team: team }
    else
      { success: false, errors: team.errors, team: team }
    end
  end

  # Remove uma equipe
  # @param [Team] team Equipe a ser removida
  # @return [Hash] Resultado da operação
  def self.destroy_team(team)
    if team.destroy
      { success: true }
    else
      { success: false, errors: team.errors }
    end
  end
end
