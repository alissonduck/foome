# app/services/page_service.rb
class PageService
  # Serviço responsável por gerenciar operações relacionadas a páginas estáticas
  # Encapsula a lógica de apresentação de páginas e seus dados

  # Obtém os dados necessários para a página inicial
  # @return [Hash] Dados para a página inicial
  def self.get_home_page_data
    {
      # Exemplo: dados que podem ser necessários para a página inicial
      # featured_restaurants: Restaurant.featured.limit(5),
      # promotions: Promotion.active.limit(3)
    }
  end
end
