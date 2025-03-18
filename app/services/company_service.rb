# app/services/company_service.rb
class CompanyService
  # Serviço responsável por gerenciar operações relacionadas a empresas
  # Encapsula a lógica de criação, atualização, busca e remoção de empresas

  # Lista todas as empresas
  # @return [ActiveRecord::Relation] Coleção de empresas
  def self.list_companies
    Company.all
  end

  # Busca uma empresa pelo ID
  # @param [Integer] id ID da empresa
  # @return [Company] Empresa encontrada
  # @raise [ActiveRecord::RecordNotFound] Caso a empresa não seja encontrada
  def self.find_company(id)
    Company.find(id)
  end

  # Cria uma nova empresa
  # @param [Hash] params Parâmetros para criação da empresa
  # @return [Hash] Resultado da operação com a empresa criada ou erros
  def self.create_company(params)
    company = Company.new(params)

    if company.save
      { success: true, company: company }
    else
      { success: false, errors: company.errors, company: company }
    end
  end

  # Atualiza uma empresa existente
  # @param [Company] company Empresa a ser atualizada
  # @param [Hash] params Parâmetros para atualização da empresa
  # @return [Hash] Resultado da operação com a empresa atualizada ou erros
  def self.update_company(company, params)
    if company.update(params)
      { success: true, company: company }
    else
      { success: false, errors: company.errors, company: company }
    end
  end

  # Remove uma empresa
  # @param [Company] company Empresa a ser removida
  # @return [Hash] Resultado da operação
  def self.destroy_company(company)
    if company.destroy
      { success: true }
    else
      { success: false, errors: company.errors }
    end
  end
end
