# app/services/session_manager_service.rb
class SessionManagerService
  # Serviço responsável por gerenciar os dados de sessão durante o processo de registro
  # Encapsula a lógica de armazenamento e recuperação de dados da sessão

  # Armazena os dados da etapa 1 na sessão
  # @param [ActionDispatch::Request::Session] session Objeto de sessão
  # @param [Hash] params Parâmetros da etapa 1
  def self.store_step_1(session, params)
    session[:employee_email] = params[:employee_email]
    session[:company_cnpj] = params[:company_cnpj]
    session[:office_city_id] = params[:office_city_id]
    session[:terms_accepted] = params[:terms_accepted]
  end

  # Armazena os dados da etapa 2 na sessão
  # @param [ActionDispatch::Request::Session] session Objeto de sessão
  # @param [Hash] params Parâmetros da etapa 2
  def self.store_step_2(session, params)
    session[:employee_name] = params[:name]
    session[:employee_phone] = params[:phone]
    session[:employee_password] = params[:password]
    session[:employee_password_confirmation] = params[:password_confirmation]
  end

  # Armazena o ID da empresa na sessão
  # @param [ActionDispatch::Request::Session] session Objeto de sessão
  # @param [Integer] company_id ID da empresa
  def self.store_company_id(session, company_id)
    session[:company_id] = company_id
  end

  # Limpa todos os dados de registro da sessão
  # @param [ActionDispatch::Request::Session] session Objeto de sessão
  def self.clear_registration_data(session)
    session.delete(:employee_email)
    session.delete(:employee_name)
    session.delete(:employee_phone)
    session.delete(:employee_password)
    session.delete(:employee_password_confirmation)
    session.delete(:company_cnpj)
    session.delete(:company_name)
    session.delete(:company_employee_count)
    session.delete(:company_work_regime)
    session.delete(:office_city_id)
    session.delete(:company_id)
    session.delete(:terms_accepted)
    session.delete(:temp_company_id)
  end

  # Verifica se os dados básicos estão presentes na sessão
  # @param [ActionDispatch::Request::Session] session Objeto de sessão
  # @return [Hash] Resultado da validação com status e eventuais erros
  def self.validate_basic_data(session)
    required_keys = [ :employee_email, :company_cnpj, :office_city_id ]
    missing_keys = required_keys.select { |key| session[key].blank? }

    if missing_keys.any?
      { success: false, missing_keys: missing_keys }
    else
      { success: true }
    end
  end

  # Verifica se os dados do administrador estão presentes na sessão
  # @param [ActionDispatch::Request::Session] session Objeto de sessão
  # @return [Hash] Resultado da validação com status e eventuais erros
  def self.validate_admin_data(session)
    admin_keys = [ :employee_name, :employee_password ]
    missing_keys = admin_keys.select { |key| session[key].blank? }

    if missing_keys.any?
      { success: false, missing_keys: missing_keys }
    else
      { success: true }
    end
  end

  # Recupera os dados do administrador da sessão
  # @param [ActionDispatch::Request::Session] session Objeto de sessão
  # @return [Hash] Dados do administrador
  def self.get_admin_data(session)
    {
      name: session[:employee_name],
      email: session[:employee_email],
      phone: session[:employee_phone],
      password: session[:employee_password],
      password_confirmation: session[:employee_password_confirmation] || session[:employee_password]
    }
  end

  # Recupera os dados da empresa da sessão
  # @param [ActionDispatch::Request::Session] session Objeto de sessão
  # @return [Hash] Dados da empresa
  def self.get_company_data(session)
    {
      cnpj: session[:company_cnpj],
      name: session[:company_name],
      employee_count: session[:company_employee_count],
      work_regime: session[:company_work_regime],
      terms_accepted: session[:terms_accepted],
      temp_id: session[:temp_company_id]
    }
  end

  # Recupera os dados do escritório da sessão
  # @param [ActionDispatch::Request::Session] session Objeto de sessão
  # @param [Hash] params Parâmetros adicionais do escritório
  # @return [Hash] Dados do escritório
  def self.get_office_data(session, params = {})
    {
      city_id: session[:office_city_id],
      zip_code: params[:zip_code],
      number: params[:number],
      neighborhood: params[:neighborhood]
    }
  end

  # Atualiza o email do funcionário na sessão
  # @param [ActionDispatch::Request::Session] session Objeto de sessão
  # @param [String] email Novo email do funcionário
  def self.update_employee_email(session, email)
    session[:employee_email] = email
  end
end
