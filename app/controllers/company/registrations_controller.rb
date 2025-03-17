class Company::RegistrationsController < ApplicationController
  layout "company_register"
  before_action :validate_session_data, only: [ :step_2, :save_step_2, :step_3, :save_step_3 ]
  before_action :set_company, only: [ :step_4, :complete ]
  before_action :redirect_if_completed, only: [ :step_2, :save_step_2, :step_3, :save_step_3, :step_4, :complete ]

  def new
    # Etapa 1 - Email, CNPJ e Cidade
    # Nesta etapa, apenas coletamos informações para uso posterior
  end

  def create
    # Processar etapa 1
    # Armazenar os dados na sessão para uso posterior
    session[:employee_email] = params[:employee][:email]
    session[:company_cnpj] = params[:company][:cnpj]
    session[:office_city_id] = params[:office][:city_id]

    # Validar os campos básicos antes de prosseguir
    @errors = []
    @errors << "Email é obrigatório" if session[:employee_email].blank?
    @errors << "CNPJ é obrigatório" if session[:company_cnpj].blank?
    @errors << "Cidade é obrigatória" if session[:office_city_id].blank?

    if @errors.any?
      flash.now[:alert] = @errors.join(", ")
      render :new, status: :unprocessable_entity
      return
    end

    redirect_to company_registrations_step_2_path
  end

  def step_2
    # Etapa 2 - Dados do administrador (nome, telefone, senha)
  end

  def save_step_2
    # Processar etapa 2
    # Validar manualmente as senhas para dar feedback antes de salvar
    if params[:employee][:password] != params[:employee][:password_confirmation]
      flash.now[:alert] = "As senhas não coincidem"
      render :step_2, status: :unprocessable_entity
      return
    end

    # Validar campos obrigatórios
    @errors = []
    @errors << "Nome completo é obrigatório" if params[:employee][:name].blank?
    @errors << "Senha é obrigatória" if params[:employee][:password].blank?

    if @errors.any?
      flash.now[:alert] = @errors.join(", ")
      render :step_2, status: :unprocessable_entity
      return
    end

    # Armazenar dados do administrador na sessão
    session[:employee_name] = params[:employee][:name]
    session[:employee_phone] = params[:employee][:phone]
    session[:employee_password] = params[:employee][:password]

    redirect_to company_registrations_step_3_path
  end

  def step_3
    # Etapa 3 - Dados da empresa (nome, número de funcionários, regime de trabalho)
  end

  def save_step_3
    # Processar etapa 3
    # Validar campos obrigatórios
    @errors = []
    @errors << "Nome da empresa é obrigatório" if params[:company][:name].blank?
    @errors << "Número de funcionários é obrigatório" if params[:company][:employee_count].blank?
    @errors << "Regime de trabalho é obrigatório" if params[:company][:work_regime].blank?

    if @errors.any?
      flash.now[:alert] = @errors.join(", ")
      render :step_3, status: :unprocessable_entity
      return
    end

    # Verificar se ainda temos o email na sessão
    if session[:employee_email].blank?
      flash.now[:alert] = "Email não encontrado. Por favor, inicie o cadastro novamente."
      redirect_to company_register_path
      return
    end

    # Criar a empresa com os dados coletados até agora
    @company = Company.new(
      name: params[:company][:name],
      email: session[:employee_email], # Usar o email do funcionário como email da empresa inicialmente
      cnpj: session[:company_cnpj],
      employee_count: params[:company][:employee_count],
      work_regime: params[:company][:work_regime]
    )

    if @company.save
      session[:company_id] = @company.id
      redirect_to company_registrations_step_4_path
    else
      flash.now[:alert] = @company.errors.full_messages.join(", ")
      render :step_3, status: :unprocessable_entity
    end
  end

  def step_4
    # Etapa 4 - Dados do escritório
    # Pré-selecionar a cidade escolhida na etapa 1
    @selected_city_id = session[:office_city_id]
  end

  def complete
    # Processar etapa 4 e finalizar cadastro
    # Validar campos obrigatórios
    @errors = []
    @errors << "CEP é obrigatório" if params[:office][:zip_code].blank?
    @errors << "Número é obrigatório" if params[:office][:number].blank?
    @errors << "Bairro é obrigatório" if params[:office][:neighborhood].blank?

    if @errors.any?
      flash.now[:alert] = @errors.join(", ")
      render :step_4, status: :unprocessable_entity
      return
    end

    # Verificar dados da sessão
    if session[:employee_name].blank? || session[:employee_email].blank? || session[:employee_password].blank?
      Rails.logger.error("Dados do administrador ausentes: name=#{session[:employee_name]}, email=#{session[:employee_email]}")
      redirect_to company_registrations_step_2_path, alert: "Dados do administrador ausentes. Por favor, preencha-os novamente."
      return
    end

    # Criar o escritório
    office = @company.offices.build(office_params)

    if office.save
      # Criar o usuário administrador
      @admin = Employee.new(
        name: session[:employee_name],
        email: session[:employee_email],
        phone: session[:employee_phone],
        password: session[:employee_password],
        company: @company,
        office: office,
        role: "admin", # Usar role em vez de admin:true
        role_name: "Administrador",
        active: true
      )

      Rails.logger.info("Criando administrador: #{@admin.attributes.inspect}")

      if @admin.save
        # Marcar cadastro como completo
        @company.update(onboarding_completed: true)

        # Limpar a sessão
        clear_registration_session

        # Autenticar o usuário
        sign_in(@admin)

        # Redirecionar para o dashboard
        redirect_to company_dashboard_path, notice: "Cadastro finalizado com sucesso! Bem-vindo(a) ao Foome."
      else
        # Se não conseguir criar o admin, excluir a empresa e o escritório para evitar inconsistências
        Rails.logger.error("Erro ao criar admin: #{@admin.errors.full_messages}")
        office.destroy
        @company.destroy
        flash.now[:alert] = @admin.errors.full_messages.join(", ")
        render :step_4, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = office.errors.full_messages.join(", ")
      render :step_4, status: :unprocessable_entity
    end
  end

  private

  def validate_session_data
    # Verificar se os dados básicos da sessão ainda existem
    required_keys = [ :employee_email, :company_cnpj, :office_city_id ]

    if step_2_or_above? && (required_keys.any? { |key| session[key].blank? })
      redirect_to company_register_path, alert: "Sessão expirada. Por favor, inicie o cadastro novamente."
      return
    end

    # Verificar dados do administrador a partir do step 3
    if step_3_or_above?
      admin_keys = [ :employee_name, :employee_password ]
      if admin_keys.any? { |key| session[key].blank? }
        redirect_to company_registrations_step_2_path, alert: "Dados do administrador ausentes. Por favor, preencha-os novamente."
        nil
      end
    end
  end

  def step_2_or_above?
    action_name.in?([ "step_2", "save_step_2", "step_3", "save_step_3", "step_4", "complete" ])
  end

  def step_3_or_above?
    action_name.in?([ "step_3", "save_step_3", "step_4", "complete" ])
  end

  def set_company
    @company = Company.find_by(id: session[:company_id])

    unless @company
      redirect_to company_register_path, alert: "Sessão expirada. Por favor, inicie o cadastro novamente."
    end
  end

  def redirect_if_completed
    if @company&.onboarding_completed?
      redirect_to "/company/login", notice: "Empresa já cadastrada. Por favor, faça login."
    end
  end

  def clear_registration_session
    session.delete(:employee_email)
    session.delete(:employee_name)
    session.delete(:employee_phone)
    session.delete(:employee_password)
    session.delete(:company_cnpj)
    session.delete(:office_city_id)
    session.delete(:company_id)
  end

  def office_params
    params.require(:office).permit(:city_id, :zip_code, :number, :neighborhood)
  end
end
