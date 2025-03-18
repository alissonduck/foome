class Company::SessionsController < ApplicationController
  # Controller responsável pelo processo de autenticação de usuários no painel da empresa
  # Gerencia o login, logout e verificação de sessão dos funcionários

  layout "company_login"

  # GET /company/login
  # Exibe o formulário de login
  def new
    # Se já estiver logado, redireciona para o dashboard
    if AuthenticationService.logged_in?(self)
      redirect_to company_dashboard_path
    end
  end

  # POST /company/login
  # Processa a autenticação do usuário
  def create
    result = AuthenticationService.authenticate(
      params[:employee][:email],
      params[:employee][:password]
    )

    if result[:success]
      employee = result[:employee]

      # Verificar se o funcionário está ativo
      if employee.active?
        # Autenticar o usuário
        AuthenticationService.sign_in(self, employee)
        redirect_to company_dashboard_path, notice: "Login realizado com sucesso!"
      else
        flash.now[:alert] = "Sua conta está inativa. Entre em contato com o administrador."
        render :new, status: :unprocessable_entity
      end
    else
      # Log da tentativa de login malsucedida
      ErrorHandlerService.log_errors(
        "Tentativa de login malsucedida",
        result[:errors],
        { email: params[:employee][:email] }
      )

      flash.now[:alert] = ErrorHandlerService.format_error_array(result[:errors])
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /company/logout
  # Encerra a sessão do usuário
  def destroy
    AuthenticationService.sign_out(self)
    redirect_to "/company/login", notice: "Logout realizado com sucesso!"
  end
end
