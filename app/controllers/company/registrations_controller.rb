class Company::RegistrationsController < ApplicationController
  # Controller responsável pelo processo de registro de empresas em etapas
  # Gerencia o fluxo de cadastro de empresas, administradores e escritórios

  layout "company_register"
  before_action :validate_session_data, only: [ :step_2, :save_step_2, :step_3, :save_step_3, :step_4 ]
  before_action :set_company, only: [ :step_4, :complete ]
  before_action :redirect_if_completed, only: [ :step_2, :save_step_2, :step_3, :save_step_3, :step_4, :complete ]

  # GET /company/register
  # Exibe o formulário da primeira etapa do registro
  def new
    # Etapa 1 - Email, CNPJ e Cidade
    # Nesta etapa, apenas coletamos informações para uso posterior
  end

  # POST /company/register
  # Processa a primeira etapa do registro
  def create
    # Processar etapa 1 - Coletar email, CNPJ, cidade e aceite dos termos
    step_params = {
      employee_email: params[:employee][:email],
      company_cnpj: params[:company][:cnpj],
      office_city_id: params[:office][:city_id],
      terms_accepted: params[:company][:terms_accepted]
    }

    # Limpar registros pendentes para este email
    if step_params[:employee_email].present?
      cleaned = clean_pending_records(step_params[:employee_email])
      Rails.logger.info("Registros pendentes removidos no step 1: #{cleaned}") if cleaned
    end

    # Validar os dados da etapa 1
    result = CompanyRegistrationService.validate_step_1(step_params)

    if result[:success]
      # Armazenar os dados na sessão
      SessionManagerService.store_step_1(session, step_params)
      redirect_to company_registrations_step_2_path
    else
      flash.now[:alert] = ErrorHandlerService.format_error_array(result[:errors])
      render :new, status: :unprocessable_entity
    end
  end

  # GET /company/registrations/step-2
  # Exibe o formulário da segunda etapa do registro
  def step_2
    # Etapa 2 - Dados do administrador (nome, telefone, senha)
    Rails.logger.info("Iniciando step_2 - Dados da sessão: #{session.to_h.reject { |k, _| k.to_s.include?('password') }}")
  end

  # PATCH /company/registrations/step-2
  # Processa a segunda etapa do registro
  def save_step_2
    # Processar etapa 2 - Coletar dados do administrador
    step_params = {
      name: params[:employee][:name],
      phone: params[:employee][:phone],
      password: params[:employee][:password],
      password_confirmation: params[:employee][:password_confirmation]
    }

    # Validar os dados da etapa 2
    result = CompanyRegistrationService.validate_step_2(step_params)

    if result[:success]
      # Armazenar os dados na sessão
      SessionManagerService.store_step_2(session, step_params)
      redirect_to company_registrations_step_3_path
    else
      flash.now[:alert] = ErrorHandlerService.format_error_array(result[:errors])
      render :step_2, status: :unprocessable_entity
    end
  end

  # GET /company/registrations/step-3
  # Exibe o formulário da terceira etapa do registro
  def step_3
    # Etapa 3 - Dados da empresa (nome, número de funcionários, regime de trabalho)
    Rails.logger.info("Iniciando step_3 - Dados da sessão: #{session.to_h.reject { |k, _| k.to_s.include?('password') }}")
  end

  # PATCH /company/registrations/step-3
  # Processa a terceira etapa do registro
  def save_step_3
    # Processar etapa 3 - Coletar dados da empresa
    company_params = {
      name: params[:company][:name],
      employee_count: params[:company][:employee_count],
      work_regime: params[:company][:work_regime]
    }

    # Validações básicas
    errors = []
    errors << "Nome da empresa é obrigatório" if company_params[:name].blank?
    errors << "Número de funcionários é obrigatório" if company_params[:employee_count].blank?
    errors << "Regime de trabalho é obrigatório" if company_params[:work_regime].blank?

    if errors.any?
      flash.now[:alert] = ErrorHandlerService.format_error_array(errors)
      render :step_3, status: :unprocessable_entity
      return
    end

    # Criar a empresa
    session_data = SessionManagerService.get_company_data(session)
    result = CompanyRegistrationService.create_company(
      company_params,
      session_data[:cnpj],
      session_data[:terms_accepted]
    )

    if result[:success]
      # Armazenar o ID da empresa na sessão
      SessionManagerService.store_company_id(session, result[:company].id)
      redirect_to company_registrations_step_4_path
    else
      flash.now[:alert] = ErrorHandlerService.format_operation_errors(result)
      render :step_3, status: :unprocessable_entity
    end
  end

  # GET /company/registrations/step-4
  # Exibe o formulário da quarta etapa do registro
  def step_4
    # Etapa 4 - Dados do escritório
    # Pré-selecionar a cidade escolhida na etapa 1
    @selected_city_id = session[:office_city_id]
    Rails.logger.info("Iniciando step_4 - Dados da sessão: #{session.to_h.reject { |k, _| k.to_s.include?('password') }}")
    Rails.logger.info("Company ID: #{session[:company_id]}, Company: #{@company&.inspect}")
  end

  # PATCH /company/registrations/complete
  # Processa a quarta etapa do registro e finaliza o cadastro
  def complete
    # Processar etapa 4 e finalizar cadastro - Coletar dados do escritório
    office_params = {
      city_id: params[:office][:city_id] || session[:office_city_id],
      zip_code: params[:office][:zip_code],
      number: params[:office][:number],
      neighborhood: params[:office][:neighborhood]
    }

    # Verificar se o usuário forneceu um novo email
    if params[:employee] && params[:employee][:email].present?
      # Atualizar o email na sessão
      SessionManagerService.update_employee_email(session, params[:employee][:email])
      Rails.logger.info("Email atualizado na sessão: #{params[:employee][:email]}")
    end

    # Obter dados do administrador da sessão
    admin_params = SessionManagerService.get_admin_data(session)

    # Tentar limpar registros pendentes para este email
    cleaned = clean_pending_records(admin_params[:email])
    Rails.logger.info("Registros pendentes removidos: #{cleaned}") if cleaned

    # Verificar se o email ainda está em uso após a limpeza
    if Employee.exists?(email: admin_params[:email])
      # Registro de debug para identificar o employee que está usando o email
      existing_employee = Employee.find_by(email: admin_params[:email])
      Rails.logger.debug("Email ainda em uso após limpeza: #{admin_params[:email]}")
      Rails.logger.debug("Employee ID: #{existing_employee.id}")
      Rails.logger.debug("Employee Company ID: #{existing_employee.company_id}")
      Rails.logger.debug("Employee criado em: #{existing_employee.created_at}")

      flash.now[:alert] = "Este email já está cadastrado. Por favor, utilize outro email."

      # Permitir que o usuário edite o email na etapa 4
      @email_in_use = true
      @current_email = admin_params[:email]
      @selected_city_id = session[:office_city_id]

      render :step_4, status: :unprocessable_entity
      return
    end

    # Finalizar o registro
    result = CompanyRegistrationService.complete_registration(
      session[:company_id],
      office_params,
      admin_params
    )

    if result[:success]
      # Limpar a sessão de registro
      SessionManagerService.clear_registration_data(session)

      # Autenticar o usuário
      AuthenticationService.sign_in(self, result[:admin])

      # Redirecionar para o dashboard
      redirect_to company_dashboard_path, notice: "Cadastro finalizado com sucesso! Bem-vindo(a) ao Foome."
    else
      # Log do erro
      ErrorHandlerService.log_errors(
        "Erro ao finalizar cadastro",
        result[:errors],
        { company_id: session[:company_id], office_params: office_params }
      )

      # Verificar se é um erro de email duplicado
      if result[:errors].any? { |e| e.include?("email já está em uso") }
        @email_in_use = true
        @current_email = admin_params[:email]
      end

      flash.now[:alert] = ErrorHandlerService.format_operation_errors(result)
      render :step_4, status: :unprocessable_entity
    end
  end

  private

  # Valida os dados da sessão para garantir que o fluxo esteja correto
  def validate_session_data
    # Verificar se os dados básicos da sessão ainda existem
    if step_2_or_above?
      result = SessionManagerService.validate_basic_data(session)

      unless result[:success]
        ErrorHandlerService.log_errors(
          "Sessão inválida - dados básicos",
          result,
          { action: action_name }
        )

        redirect_to company_register_path, alert: ErrorHandlerService.format_session_validation_errors(result)
        return
      end
    end

    # Verificar dados do administrador a partir do step 3
    if step_3_or_above?
      result = SessionManagerService.validate_admin_data(session)

      unless result[:success]
        ErrorHandlerService.log_errors(
          "Sessão inválida - dados do administrador",
          result,
          { action: action_name }
        )

        redirect_to company_registrations_step_2_path, alert: ErrorHandlerService.format_session_validation_errors(result)
        nil
      end
    end
  end

  # Verifica se a ação atual é step 2 ou posterior
  def step_2_or_above?
    action_name.in?([ "step_2", "save_step_2", "step_3", "save_step_3", "step_4", "complete" ])
  end

  # Verifica se a ação atual é step 3 ou posterior
  def step_3_or_above?
    action_name.in?([ "step_3", "save_step_3", "step_4", "complete" ])
  end

  # Carrega a empresa atual da sessão
  def set_company
    @company = Company.find_by(id: session[:company_id])

    unless @company
      redirect_to company_register_path, alert: "Sessão expirada. Por favor, inicie o cadastro novamente."
    end
  end

  # Redireciona se a empresa já completou o cadastro
  def redirect_if_completed
    if @company&.onboarding_completed?
      redirect_to "/company/login", notice: "Empresa já cadastrada. Por favor, faça login."
    end
  end

  # Limpa registros pendentes (incompletos) do email atual
  # @param [String] email Email a ser verificado
  def clean_pending_records(email)
    # Encontrar employees pendentes com este email
    pending_employees = Employee.joins(:company)
                              .where(email: email)
                              .where(companies: { onboarding_completed: false })

    if pending_employees.any?
      Rails.logger.info("Removendo #{pending_employees.count} registros pendentes para o email: #{email}")

      # Remover employees pendentes e suas companies
      pending_employees.each do |employee|
        company_id = employee.company_id
        Rails.logger.info("Removendo employee ID: #{employee.id} e company ID: #{company_id}")

        # Remover em uma transação para garantir a consistência
        ActiveRecord::Base.transaction do
          # Destruir o employee
          employee.destroy

          # Verificar se a company existe e se não tem outros employees
          company = Company.find_by(id: company_id)
          if company && company.employees.count == 0
            # Remover escritórios
            company.offices.destroy_all
            # Remover a company
            company.destroy
          end
        end
      end

      return true
    end

    false
  end
end
