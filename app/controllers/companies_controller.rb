class CompaniesController < ApplicationController
  before_action :set_company, only: %i[ show edit update destroy ]

  # GET /companies or /companies.json
  def index
    @companies = CompanyService.list_companies
  end

  # GET /companies/1 or /companies/1.json
  def show
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies or /companies.json
  def create
    result = CompanyService.create_company(company_params)
    @company = result[:company]

    respond_to do |format|
      if result[:success]
        format.html { redirect_to @company, notice: "Empresa criada com sucesso." }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1 or /companies/1.json
  def update
    result = CompanyService.update_company(@company, company_params)

    respond_to do |format|
      if result[:success]
        format.html { redirect_to @company, notice: "Empresa atualizada com sucesso." }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1 or /companies/1.json
  def destroy
    result = CompanyService.destroy_company(@company)

    respond_to do |format|
      if result[:success]
        format.html { redirect_to companies_path, status: :see_other, notice: "Empresa removida com sucesso." }
        format.json { head :no_content }
      else
        format.html { redirect_to @company, alert: "Erro ao remover empresa: #{ErrorHandlerService.format_operation_errors(result)}" }
        format.json { render json: result[:errors], status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = CompanyService.find_company(params[:id])
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.html { redirect_to companies_path, alert: "Empresa não encontrada." }
        format.json { render json: { error: "Empresa não encontrada" }, status: :not_found }
      end
    end

    # Only allow a list of trusted parameters through.
    def company_params
      params.require(:company).permit(:name, :cnpj, :employee_count, :work_regime, :max_users, :active, :onboarding_completed, :terms_accepted)
    end
end
