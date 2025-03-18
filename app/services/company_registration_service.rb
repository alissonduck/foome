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

    # Verificar se o email já está em uso
    if params[:employee_email].present? && Employee.exists?(email: params[:employee_email])
      errors << "Este email já está em uso. Por favor, utilize outro email."
    end

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
    # Verificar se já existe um funcionário com esse email
    if Employee.exists?(email: params[:email])
      return { success: false, errors: [ "Este email já está em uso. Por favor, utilize outro email." ] }
    end

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
  # @param [Hash] company_params Parâmetros da empresa
  # @param [Hash] office_params Parâmetros do escritório
  # @param [Hash] admin_params Parâmetros do administrador
  # @return [Hash] Resultado da operação
  def self.complete_registration(company_params, office_params, admin_params)
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

    # Validar dados da empresa
    company_errors = []
    company_errors << "Nome da empresa é obrigatório" if company_params[:name].blank?
    company_errors << "CNPJ é obrigatório" if company_params[:cnpj].blank?

    return { success: false, errors: company_errors } if company_errors.any?

    # Verificar se o email já está em uso
    if Employee.exists?(email: admin_params[:email])
      return { success: false, errors: [ "Este email já está em uso. Por favor, utilize outro email." ] }
    end

    # Usamos uma transação para garantir que tudo seja criado ou nada
    ActiveRecord::Base.transaction do
      begin
        # Criar a empresa
        company = Company.new(
          name: company_params[:name],
          cnpj: company_params[:cnpj],
          employee_count: company_params[:employee_count],
          work_regime: company_params[:work_regime],
          terms_accepted: company_params[:terms_accepted] == "1",
          onboarding_completed: false
        )

        unless company.save
          Rails.logger.error("Erro ao criar empresa: #{company.errors.full_messages}")
          return { success: false, errors: company.errors.full_messages }
        end

        Rails.logger.info("Empresa criada com sucesso: #{company.id}")

        # Criar escritório
        office = company.offices.new(
          name: "Escritório Principal",
          city_id: office_params[:city_id],
          zip_code: office_params[:zip_code],
          number: office_params[:number],
          neighborhood: office_params[:neighborhood]
        )

        unless office.save
          Rails.logger.error("Erro ao criar escritório: #{office.errors.full_messages}")
          raise ActiveRecord::Rollback
          return { success: false, errors: office.errors.full_messages }
        end

        Rails.logger.info("Escritório criado com sucesso: #{office.id}")

        # Criar administrador
        admin = company.employees.new(
          name: admin_params[:name],
          email: admin_params[:email],
          phone: admin_params[:phone],
          password: admin_params[:password],
          password_confirmation: admin_params[:password_confirmation] || admin_params[:password],
          office: office,
          role: "admin",
          active: true
        )

        unless admin.save
          Rails.logger.error("Erro ao criar administrador: #{admin.errors.full_messages}")
          raise ActiveRecord::Rollback
          return { success: false, errors: admin.errors.full_messages }
        end

        Rails.logger.info("Administrador criado com sucesso: #{admin.id}")

        # Marcar cadastro como completo
        company.update(onboarding_completed: true)

        return { success: true, admin: admin, company: company }
      rescue => e
        Rails.logger.error("Erro durante o processo de registro: #{e.message}")
        Rails.logger.error(e.backtrace.join("\n"))
        raise ActiveRecord::Rollback
        return { success: false, errors: [ e.message ] }
      end
    end

    # Se chegou aqui, é porque ocorreu um rollback
    { success: false, errors: [ "Erro ao completar o registro. Verifique se o email já está em uso." ] }
  end
end
