class Company::RegistrationsController < ApplicationController
  # Controller responsável pelo processo de registro de empresas em etapas
  # Gerencia o fluxo de cadastro de empresas, administradores e escritórios

  layout "company_register"
  before_action :validate_session_data, only: [ :step_2, :save_step_2, :step_3, :save_step_3, :step_4, :complete ]
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

    # Armazenar os dados da empresa na sessão - não criar a empresa ainda
    session[:company_name] = company_params[:name]
    session[:company_employee_count] = company_params[:employee_count]
    session[:company_work_regime] = company_params[:work_regime]

    # Criar uma chave temporária para identificar a empresa
    session[:temp_company_id] = SecureRandom.uuid

    Rails.logger.info("Dados da empresa armazenados na sessão: #{company_params.inspect}")

    redirect_to company_registrations_step_4_path
  end

  # GET /company/registrations/step-4
  # Exibe o formulário da quarta etapa do registro
  def step_4
    # Etapa 4 - Dados do escritório
    # Pré-selecionar a cidade escolhida na etapa 1
    @selected_city_id = session[:office_city_id]
    Rails.logger.info("Iniciando step_4 - Dados da sessão: #{session.to_h.reject { |k, _| k.to_s.include?('password') }}")

    # Neste ponto, possivelmente não teremos mais a empresa criada
    if session[:company_id].present?
      company = Company.find_by(id: session[:company_id])
      Rails.logger.info("Company ID: #{session[:company_id]}, Company: #{company&.inspect}")
    else
      Rails.logger.info("Sem company_id na sessão - usando dados temporários da sessão")
      Rails.logger.info("Company name: #{session[:company_name]}")
      Rails.logger.info("Company temp_id: #{session[:temp_company_id]}")
    end
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

    # Obter dados da empresa da sessão
    company_params = SessionManagerService.get_company_data(session)

    # Tentar limpar registros pendentes para este email
    email = admin_params[:email]
    cleaned = clean_pending_records(email)
    Rails.logger.info("Registros pendentes removidos: #{cleaned} para email: #{email}")

    # Verificar se o email ainda está em uso após a limpeza
    if Employee.exists?(email: email)
      # Medida drástica: tentar remover qualquer registro com este email diretamente
      Rails.logger.warn("Tentando medida drástica para remover employee com email: #{email}")
      begin
        # Executar SQL direto para garantir que o registro seja removido
        employee_ids = Employee.where(email: email).pluck(:id)

        if employee_ids.any?
          Rails.logger.warn("Removendo diretamente employees com IDs: #{employee_ids.join(', ')}")

          # Tentativa de remover via SQL direto em último caso
          Employee.where(id: employee_ids).delete_all

          # Verificar se a remoção foi bem-sucedida
          still_exists = Employee.exists?(email: email)

          if still_exists
            # Se ainda existir, procurar por dependências que podem estar impedindo a remoção
            existing_employee = Employee.find_by(email: email)
            Rails.logger.error("Não foi possível remover employee ID: #{existing_employee.id}")
            Rails.logger.error("Employee pertence à empresa ID: #{existing_employee.company_id}")

            # Registrar detalhes adicionais para diagnóstico
            company = Company.find_by(id: existing_employee.company_id)
            if company
              Rails.logger.error("Empresa existe? Sim. Onboarding completo? #{company.onboarding_completed}")
              Rails.logger.error("Empresa tem #{company.employees.count} employees")
            else
              Rails.logger.error("Empresa não encontrada (possível registro órfão)")
            end

            # Informar o usuário sobre o problema
            flash.now[:alert] = "Este email já está em uso e não foi possível liberá-lo. Por favor, utilize outro email ou entre em contato com o suporte."
            @email_in_use = true
            @current_email = email
            @selected_city_id = session[:office_city_id]
            render :step_4, status: :unprocessable_entity
            return
          end
        end
      rescue => e
        Rails.logger.error("Erro ao tentar remover diretamente: #{e.message}")
        Rails.logger.error(e.backtrace.join("\n"))
      end
    end

    # Verificar novamente se o email está livre
    if Employee.exists?(email: email)
      flash.now[:alert] = "Este email já está cadastrado. Por favor, utilize outro email."
      @email_in_use = true
      @current_email = email
      @selected_city_id = session[:office_city_id]
      render :step_4, status: :unprocessable_entity
      return
    end

    # Finalizar o registro - criando a empresa, escritório e administrador em uma única transação
    result = CompanyRegistrationService.complete_registration(
      company_params,
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
        { company_params: company_params, office_params: office_params }
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

  # Limpa registros pendentes (incompletos) do email atual
  # @param [String] email Email a ser verificado
  def clean_pending_records(email)
    return false if email.blank?

    # Log para depuração
    Rails.logger.info("Iniciando limpeza de registros para o email: #{email}")

    # Verificar diretamente se existe um employee com este email
    employee_exists = Employee.exists?(email: email)
    Rails.logger.info("Existe employee com este email? #{employee_exists}")

    if employee_exists
      # Encontrar todos os employees com este email, independente do status da empresa
      employees = Employee.where(email: email)

      Rails.logger.info("Encontrados #{employees.count} employees com este email")

      # Para cada employee, remover ele e possivelmente sua empresa
      employees.each do |employee|
        company_id = employee.company_id
        company = Company.find_by(id: company_id)

        # Log detalhado sobre o employee e sua empresa
        Rails.logger.info("Employee ID: #{employee.id}, Company ID: #{company_id}")
        Rails.logger.info("Empresa #{company_id} tem onboarding completo? #{company&.onboarding_completed}")

        # Remover em uma transação para garantir a consistência
        ActiveRecord::Base.transaction do
          begin
            # Verificar se há outros employees na mesma empresa
            other_employees = company.employees.where.not(id: employee.id).count if company

            # Remover o employee
            if employee.destroy
              Rails.logger.info("Employee #{employee.id} removido com sucesso")
            else
              Rails.logger.error("Falha ao remover employee #{employee.id}: #{employee.errors.full_messages.join(', ')}")
            end

            # Verificar se a empresa existe e se não tem outros employees
            if company && (other_employees.nil? || other_employees == 0)
              # Remover escritórios
              if company.offices.any?
                company.offices.destroy_all
                Rails.logger.info("Escritórios da empresa #{company_id} removidos")
              end

              # Remover a empresa
              if company.destroy
                Rails.logger.info("Empresa #{company_id} removida com sucesso")
              else
                Rails.logger.error("Falha ao remover empresa #{company_id}: #{company.errors.full_messages.join(', ')}")
              end
            else
              Rails.logger.info("Empresa #{company_id} não será removida pois tem outros #{other_employees} employees")
            end
          rescue => e
            Rails.logger.error("Erro durante limpeza: #{e.message}")
            Rails.logger.error(e.backtrace.join("\n"))
            raise ActiveRecord::Rollback
          end
        end
      end

      # Verificar se a limpeza foi eficaz
      still_exists = Employee.exists?(email: email)
      Rails.logger.info("Após limpeza, ainda existe employee com este email? #{still_exists}")

      return !still_exists
    end

    false
  end

  # Redireciona se a empresa já completou o cadastro
  def redirect_if_completed
    # Verificar se o email já foi registrado em uma empresa com onboarding completo
    email = session[:employee_email]

    if email.present?
      existing_employee = Employee.joins(:company)
                               .where(email: email)
                               .where(companies: { onboarding_completed: true })
                               .first

      if existing_employee
        Rails.logger.info("Email #{email} já está registrado em empresa com onboarding completo")
        company = existing_employee.company
        redirect_to "/company/login", notice: "Você já possui uma conta registrada. Por favor, faça login."
        nil
      end
    end
  end
end
