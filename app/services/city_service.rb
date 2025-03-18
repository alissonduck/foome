# app/services/city_service.rb
class CityService
  # Serviço responsável por gerenciar operações relacionadas a cidades
  # Encapsula a lógica de busca, filtragem e consulta de cidades

  # Lista todas as cidades ou filtra por estado
  # @param [Integer, nil] state_id ID do estado para filtrar cidades
  # @return [ActiveRecord::Relation] Coleção de cidades
  def self.list_cities(state_id = nil)
    if state_id.present?
      City.where(state_id: state_id).order(:name)
    else
      City.all.includes(:state).order(:name)
    end
  end

  # Busca uma cidade pelo ID
  # @param [Integer] id ID da cidade
  # @return [City] Cidade encontrada
  # @raise [ActiveRecord::RecordNotFound] Caso a cidade não seja encontrada
  def self.find_city(id)
    City.find(id)
  end

  # Busca cidades por termo de pesquisa
  # @param [String] query Termo para pesquisa
  # @param [Integer] limit Limite de resultados (padrão: 10)
  # @return [ActiveRecord::Relation] Coleção de cidades que correspondem à pesquisa
  def self.search_cities(query, limit = 10)
    query = query.to_s.downcase
    City.where("LOWER(name) LIKE ?", "%#{query}%")
        .includes(:state)
        .order(:name)
        .limit(limit)
  end
end
