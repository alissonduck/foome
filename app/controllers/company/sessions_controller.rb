class Company::SessionsController < ApplicationController
  layout "company_login"

  def new
    # Se já estiver logado, redireciona para o dashboard
    if employee_signed_in?
      redirect_to company_dashboard_path
    end
  end

  def create
    employee = Employee.find_by(email: params[:employee][:email])

    if employee && employee.valid_password?(params[:employee][:password])
      if employee.active?
        sign_in(employee)
        redirect_to company_dashboard_path, notice: "Login realizado com sucesso!"
      else
        flash.now[:alert] = "Sua conta está inativa. Entre em contato com o administrador."
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Email ou senha inválidos."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    sign_out current_employee
    redirect_to "/company/login", notice: "Logout realizado com sucesso!"
  end
end
