# app/services/authentication_service.rb
class AuthenticationService
  # Serviço responsável por gerenciar a autenticação de usuários
  # Encapsula a lógica de login e logout

  # Autentica um usuário com email e senha
  # @param [String] email Email do usuário
  # @param [String] password Senha do usuário
  # @return [Hash] Resultado da operação com o usuário ou erros
  def self.authenticate(email, password)
    return { success: false, errors: [ "Email é obrigatório" ] } if email.blank?
    return { success: false, errors: [ "Senha é obrigatória" ] } if password.blank?

    employee = Employee.find_by(email: email)

    if employee && employee.valid_password?(password)
      { success: true, employee: employee }
    else
      { success: false, errors: [ "Email ou senha inválidos" ] }
    end
  end

  # Faz login do usuário na aplicação
  # @param [ActionController::Base] controller Controlador atual
  # @param [Employee] employee Empregado a ser autenticado
  def self.sign_in(controller, employee)
    controller.session[:employee_id] = employee.id
  end

  # Faz logout do usuário na aplicação
  # @param [ActionController::Base] controller Controlador atual
  def self.sign_out(controller)
    controller.session.delete(:employee_id)
  end

  # Verifica se o usuário está logado
  # @param [ActionController::Base] controller Controlador atual
  # @return [Boolean] True se o usuário estiver logado
  def self.logged_in?(controller)
    controller.session[:employee_id].present?
  end

  # Obtém o usuário logado
  # @param [ActionController::Base] controller Controlador atual
  # @return [Employee, nil] Usuário logado ou nil
  def self.current_user(controller)
    return nil unless controller.session[:employee_id]

    @current_user ||= Employee.find_by(id: controller.session[:employee_id])
  end
end
