# app/services/dashboard_service.rb
class DashboardService
  # Serviço responsável por gerenciar as operações relacionadas ao dashboard
  # Encapsula a lógica de recuperação e processamento de dados para o dashboard

  # Recupera as informações da empresa para exibição no dashboard
  # @param [Integer] company_id ID da empresa
  # @return [Hash] Resultado com os dados da empresa ou erros
  def self.get_company_info(company_id)
    company = Company.find_by(id: company_id)

    if company
      {
        success: true,
        company: company,
        offices_count: company.offices.count,
        employees_count: company.employees.count,
        teams_count: company.teams.count
      }
    else
      { success: false, errors: [ "Empresa não encontrada" ] }
    end
  end

  # Recupera estatísticas de funcionários para o dashboard
  # @param [Integer] company_id ID da empresa
  # @return [Hash] Resultado com estatísticas de funcionários
  def self.get_employee_stats(company_id)
    company = Company.find_by(id: company_id)
    return { success: false, errors: [ "Empresa não encontrada" ] } unless company

    active_employees = company.employees.where(active: true).count
    inactive_employees = company.employees.where(active: false).count

    admin_count = company.employees.where(role: "admin").count

    {
      success: true,
      stats: {
        total: company.employees.count,
        active: active_employees,
        inactive: inactive_employees,
        admins: admin_count
      }
    }
  end

  # Recupera estatísticas de escritórios para o dashboard
  # @param [Integer] company_id ID da empresa
  # @return [Hash] Resultado com estatísticas de escritórios
  def self.get_office_stats(company_id)
    company = Company.find_by(id: company_id)
    return { success: false, errors: [ "Empresa não encontrada" ] } unless company

    offices = company.offices

    # Agrupar escritórios por estado
    offices_by_state = offices.joins(city: :state)
                             .group("states.name")
                             .count

    {
      success: true,
      stats: {
        total: offices.count,
        by_state: offices_by_state
      }
    }
  end

  # Recupera todas as informações necessárias para o dashboard
  # @param [Integer] company_id ID da empresa
  # @return [Hash] Resultado com todos os dados do dashboard
  def self.get_dashboard_data(company_id)
    company_info = get_company_info(company_id)
    return { success: false, errors: company_info[:errors] } unless company_info[:success]

    employee_stats = get_employee_stats(company_id)
    office_stats = get_office_stats(company_id)

    {
      success: true,
      company: company_info[:company],
      offices: {
        count: company_info[:offices_count],
        stats: office_stats[:success] ? office_stats[:stats] : {}
      },
      employees: {
        count: company_info[:employees_count],
        stats: employee_stats[:success] ? employee_stats[:stats] : {}
      },
      teams: {
        count: company_info[:teams_count]
      }
    }
  end
end
