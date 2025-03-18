# app/services/office_service.rb
class OfficeService
  # Serviço responsável por gerenciar operações relacionadas a escritórios
  # Encapsula a lógica de criação, atualização, busca e remoção de escritórios

  # Lista todos os escritórios da empresa atual
  # @param [Company] company Empresa atual
  # @return [ActiveRecord::Relation] Coleção de escritórios
  def self.list_offices
    Office.where(company_id: Current.company.id)
  end

  # Busca um escritório pelo ID
  # @param [Integer] id ID do escritório
  # @return [Office] Escritório encontrado
  # @raise [ActiveRecord::RecordNotFound] Caso o escritório não seja encontrado
  def self.find_office(id)
    Office.where(company_id: Current.company.id).find(id)
  end

  # Cria um novo escritório
  # @param [Hash] params Parâmetros para criação do escritório
  # @return [Hash] Resultado da operação com o escritório criado ou erros
  def self.create_office(params)
    office = Office.new(params)

    if office.save
      { success: true, office: office }
    else
      { success: false, errors: office.errors.full_messages, office: office }
    end
  end

  # Atualiza um escritório existente
  # @param [Office] office Escritório a ser atualizado
  # @param [Hash] params Parâmetros para atualização do escritório
  # @return [Hash] Resultado da operação com o escritório atualizado ou erros
  def self.update_office(office, params)
    if office.update(params)
      { success: true, office: office }
    else
      { success: false, errors: office.errors.full_messages, office: office }
    end
  end

  # Remove um escritório
  # @param [Office] office Escritório a ser removido
  # @return [Hash] Resultado da operação
  def self.destroy_office(office)
    if office.destroy
      { success: true }
    else
      { success: false, errors: office.errors.full_messages }
    end
  end
end
