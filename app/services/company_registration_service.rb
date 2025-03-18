class CompanyRegistrationService
  # Serviço responsável por gerenciar o processo de registro de empresas
  # Encapsula a lógica de negócio relacionada ao registro de empresas em etapas

  # Inicializa a primeira etapa do registro (email, cnpj, cidade)
  # @param [Hash] params Parâmetros do primeiro passo do registro
  # @return [Hash] Resultado da operação com status e eventuais erros
  def self.validate_step_1(params)
    errors = []
    errors << "Email é obrigatório" if params[:employee_email].blank?
    errors << "CNPJ é obrigatório" if params[:company_cnpj].blank?
    errors << "Cidade é obrigatória" if params[:office_city_id].blank?
    errors << "É necessário aceitar os termos de uso e política de privacidade" if params[:terms_accepted] != "1"

    if errors.any?
      { success: false, errors: errors }
    else
      { success: true }
    end
  end

  # Valida o segundo passo do registro (dados do administrador)
  # @param [Hash] params Parâmetros do segundo passo
  # @return [Hash] Resultado da validação com status e eventuais erros
  def self.validate_step_2(params)
    errors = []

    # Validar senhas
    if params[:password] != params[:password_confirmation]
      errors << "As senhas não coincidem"
    end

    # Validar campos obrigatórios
    errors << "Nome completo é obrigatório" if params[:name].blank?
    errors << "Senha é obrigatória" if params[:password].blank?

    if errors.any?
      { success: false, errors: errors }
    else
      { success: true }
    end
  end

  # Cria a empresa com os dados do terceiro passo
  # @param [Hash] params Parâmetros da empresa
  # @param [String] cnpj CNPJ da empresa obtido no primeiro passo
  # @param [Boolean] terms_accepted Aceitação dos termos
  # @return [Hash] Resultado da operação com a empresa criada ou erros
  def self.create_company(params, cnpj, terms_accepted)
    company = Company.new(
      name: params[:name],
      cnpj: cnpj,
      employee_count: params[:employee_count],
      work_regime: params[:work_regime],
      terms_accepted: terms_accepted == "1"
    )

    if company.save
      { success: true, company: company }
    else
      { success: false, errors: company.errors.full_messages }
    end
  end

  # Cria o escritório principal para a empresa
  # @param [Integer] company_id ID da empresa
  # @param [Hash] params Parâmetros do escritório
  # @return [Hash] Resultado da operação com o escritório criado ou erros
  def self.create_office(company_id, params)
    company = Company.find_by(id: company_id)
    return { success: false, errors: [ "Empresa não encontrada" ] } unless company

    office = company.offices.new(
      name: "Escritório Principal",
      city_id: params[:city_id],
      zip_code: params[:zip_code],
      number: params[:number],
      complement: params[:complement],
      neighborhood: params[:neighborhood]
    )

    if office.save
      { success: true, office: office }
    else
      { success: false, errors: office.errors.full_messages }
    end
  end

  # Cria o administrador da empresa
  # @param [Company] company Empresa
  # @param [Office] office Escritório principal
  # @param [Hash] params Parâmetros do administrador
  # @return [Hash] Resultado da operação com o administrador criado ou erros
  def self.create_admin(company, office, params)
    admin = company.employees.new(
      name: params[:name],
      email: params[:email],
      phone: params[:phone],
      password: params[:password],
      password_confirmation: params[:password_confirmation] || params[:password],
      office: office,
      role: "admin",
      active: true
    )

    if admin.save
      # Marcar cadastro como completo
      company.update(onboarding_completed: true)
      { success: true, admin: admin }
    else
      { success: false, errors: admin.errors.full_messages }
    end
  rescue => e
    { success: false, errors: [ e.message ] }
  end

  # Finaliza o processo de registro
  # @param [Integer] company_id ID da empresa
  # @param [Hash] office_params Parâmetros do escritório
  # @param [Hash] admin_params Parâmetros do administrador
  # @return [Hash] Resultado da operação
  def self.complete_registration(company_id, office_params, admin_params)
    # Validar parâmetros do escritório
    office_errors = []
    office_errors << "CEP é obrigatório" if office_params[:zip_code].blank?
    office_errors << "Número é obrigatório" if office_params[:number].blank?
    office_errors << "Bairro é obrigatório" if office_params[:neighborhood].blank?

    return { success: false, errors: office_errors } if office_errors.any?

    # Validar dados do administrador
    admin_errors = []
    admin_errors << "Nome do administrador é obrigatório" if admin_params[:name].blank?
    admin_errors << "Email do administrador é obrigatório" if admin_params[:email].blank?
    admin_errors << "Senha do administrador é obrigatória" if admin_params[:password].blank?

    return { success: false, errors: admin_errors } if admin_errors.any?

    company = Company.find_by(id: company_id)
    return { success: false, errors: [ "Empresa não encontrada" ] } unless company

    # Usamos uma transação para garantir que tudo seja criado ou nada
    ActiveRecord::Base.transaction do
      # Criar escritório
      office_result = create_office(company_id, office_params)
      raise ActiveRecord::Rollback unless office_result[:success]

      # Criar administrador
      admin_result = create_admin(company, office_result[:office], admin_params)
      raise ActiveRecord::Rollback unless admin_result[:success]

      return { success: true, admin: admin_result[:admin], company: company }
    end

    # Se chegou aqui, é porque ocorreu um rollback
    { success: false, errors: [ "Erro ao completar o registro" ] }
  end
end
