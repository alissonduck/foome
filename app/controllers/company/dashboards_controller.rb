class Company::DashboardsController < ApplicationController
  # Controller responsável pelo dashboard da empresa
  # Gerencia a exibição e interação com os dados do dashboard

  before_action :authenticate_employee
  layout "company_dashboard"
  helper_method :current_employee

  # GET /company/dashboard
  # Exibe o dashboard principal da empresa
  def index
    # Obter o funcionário atual
    @employee = current_employee
    return redirect_to "/company/login", alert: "Você precisa estar logado para acessar esta página." unless @employee

    # Obter os dados do dashboard
    @company = @employee.company

    # Inicializar dados do dashboard
    @dashboard_data = {
      company: @company,
      offices: {
        count: @company.offices.count,
        stats: { by_state: {} }
      },
      employees: {
        count: @company.employees.count,
        stats: {
          active: @company.employees.where(active: true).count,
          inactive: @company.employees.where(active: false).count
        }
      },
      teams: {
        count: 0 # Implementar quando tivermos o modelo de equipes
      }
    }

    # Agrupar escritórios por estado se houver escritórios
    if @company.offices.any?
      @dashboard_data[:offices][:stats][:by_state] = @company.offices
                                                     .joins(city: :state)
                                                     .group("states.name")
                                                     .count
    end
  end

  # GET /company/dashboard/employees
  # Exibe o dashboard de funcionários
  def employees
    # Obter o funcionário atual
    @employee = current_employee
    return redirect_to "/company/login", alert: "Você precisa estar logado para acessar esta página." unless @employee

    # Obter estatísticas de funcionários
    @company = @employee.company
    @employees = @company.employees.order(:name)

    @employee_stats = {
      total: @employees.count,
      active: @employees.where(active: true).count,
      inactive: @employees.where(active: false).count,
      admins: @employees.where(role: "admin").count
    }
  end

  # GET /company/dashboard/offices
  # Exibe o dashboard de escritórios
  def offices
    # Obter o funcionário atual
    @employee = current_employee
    return redirect_to "/company/login", alert: "Você precisa estar logado para acessar esta página." unless @employee

    # Obter estatísticas de escritórios
    @company = @employee.company
    @offices = @company.offices.includes(city: :state).order("cities.name")

    # Agrupar escritórios por estado
    @office_stats = {
      total: @offices.count,
      by_state: @offices.joins(city: :state)
                       .group("states.name")
                       .count
    }
  end

  private

  # Verifica se o usuário está autenticado
  def authenticate_employee
    unless logged_in?
      redirect_to "/company/login", alert: "Você precisa estar logado para acessar esta página."
    end
  end

  # Verifica se o usuário está logado
  def logged_in?
    AuthenticationService.logged_in?(self)
  end

  # Retorna o funcionário atual
  def current_employee
    @current_employee ||= AuthenticationService.current_user(self)
  end
end
