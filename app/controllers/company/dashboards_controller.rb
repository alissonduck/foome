class Company::DashboardsController < ApplicationController
  # Controller responsável pelo dashboard da empresa
  # Gerencia a exibição e interação com os dados do dashboard

  before_action :authenticate_employee
  layout "company_dashboard"

  # GET /company/dashboard
  # Exibe o dashboard principal da empresa
  def index
    # Obter o funcionário atual
    employee = AuthenticationService.current_user(self)
    return redirect_to "/company/login", alert: "Você precisa estar logado para acessar esta página." unless employee

    # Obter os dados do dashboard
    result = DashboardService.get_dashboard_data(employee.company_id)

    if result[:success]
      @company = result[:company]
      @dashboard_data = result

      # Obter estatísticas adicionais se necessário
      # Renderizar o dashboard
    else
      # Log do erro
      ErrorHandlerService.log_errors(
        "Erro ao carregar dashboard",
        result[:errors],
        { employee_id: employee.id, company_id: employee.company_id }
      )

      # Redirecionar com mensagem de erro
      redirect_to "/company/login", alert: "Não foi possível carregar o dashboard. Por favor, tente novamente."
    end
  end

  # GET /company/dashboard/employees
  # Exibe o dashboard de funcionários
  def employees
    # Obter o funcionário atual
    employee = AuthenticationService.current_user(self)
    return redirect_to "/company/login", alert: "Você precisa estar logado para acessar esta página." unless employee

    # Obter estatísticas de funcionários
    result = DashboardService.get_employee_stats(employee.company_id)

    if result[:success]
      @company = Company.find(employee.company_id)
      @employee_stats = result[:stats]
      @employees = @company.employees.order(:name)

      # Renderizar o dashboard de funcionários
    else
      # Log do erro
      ErrorHandlerService.log_errors(
        "Erro ao carregar dashboard de funcionários",
        result[:errors],
        { employee_id: employee.id, company_id: employee.company_id }
      )

      # Redirecionar com mensagem de erro
      redirect_to company_dashboard_path, alert: "Não foi possível carregar as estatísticas de funcionários."
    end
  end

  # GET /company/dashboard/offices
  # Exibe o dashboard de escritórios
  def offices
    # Obter o funcionário atual
    employee = AuthenticationService.current_user(self)
    return redirect_to "/company/login", alert: "Você precisa estar logado para acessar esta página." unless employee

    # Obter estatísticas de escritórios
    result = DashboardService.get_office_stats(employee.company_id)

    if result[:success]
      @company = Company.find(employee.company_id)
      @office_stats = result[:stats]
      @offices = @company.offices.includes(city: :state).order("cities.name")

      # Renderizar o dashboard de escritórios
    else
      # Log do erro
      ErrorHandlerService.log_errors(
        "Erro ao carregar dashboard de escritórios",
        result[:errors],
        { employee_id: employee.id, company_id: employee.company_id }
      )

      # Redirecionar com mensagem de erro
      redirect_to company_dashboard_path, alert: "Não foi possível carregar as estatísticas de escritórios."
    end
  end

  private

  # Verifica se o usuário está autenticado
  def authenticate_employee
    unless AuthenticationService.logged_in?(self)
      redirect_to "/company/login", alert: "Você precisa estar logado para acessar esta página."
    end
  end
end
