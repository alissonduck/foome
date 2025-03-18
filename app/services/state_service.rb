# app/services/state_service.rb
class StateService
  # Serviço responsável por gerenciar operações relacionadas a estados
  # Encapsula a lógica de busca e consulta de estados

  # Lista todos os estados ordenados por nome
  # @return [ActiveRecord::Relation] Coleção de estados
  def self.list_states
    State.all.order(:name)
  end

  # Busca um estado pelo ID
  # @param [Integer] id ID do estado
  # @return [State] Estado encontrado
  # @raise [ActiveRecord::RecordNotFound] Caso o estado não seja encontrado
  def self.find_state(id)
    State.find(id)
  end

  # Busca um estado pela sigla
  # @param [String] abbreviation Sigla do estado
  # @return [State] Estado encontrado
  # @raise [ActiveRecord::RecordNotFound] Caso o estado não seja encontrado
  def self.find_by_abbreviation(abbreviation)
    State.find_by!(abbreviation: abbreviation.upcase)
  end

  # Obtém as cidades de um estado ordenadas por nome
  # @param [State] state Estado
  # @return [ActiveRecord::Relation] Coleção de cidades
  def self.cities_for_state(state)
    state.cities.order(:name)
  end
end
