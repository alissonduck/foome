module Company
  class OfficesController < CompanyController
    before_action :set_office, only: %i[ show edit update destroy ]

    # GET /company/offices
    def index
      @offices = current_company.offices.includes(city: :state).order(:name)
    end

    # GET /company/offices/new
    def new
      @office = current_company.offices.build
    end

    # GET /company/offices/1/edit
    def edit
    end

    # POST /company/offices
    def create
      @office = current_company.offices.build(office_params)

      respond_to do |format|
        if @office.save
          format.html { redirect_to company_offices_path, notice: "Escritório criado com sucesso." }
          format.json { render :show, status: :created, location: company_office_path(@office) }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @office.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /company/offices/1
    def update
      respond_to do |format|
        if @office.update(office_params)
          format.html { redirect_to company_offices_path, notice: "Escritório atualizado com sucesso." }
          format.json { render :show, status: :ok, location: company_office_path(@office) }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @office.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /company/offices/1
    def destroy
      if @office.employees.exists?
        redirect_to company_offices_path, alert: "Não é possível excluir um escritório que possui funcionários."
      else
        @office.destroy
        respond_to do |format|
          format.html { redirect_to company_offices_path, notice: "Escritório removido com sucesso.", status: :see_other }
          format.json { head :no_content }
        end
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_office
        @office = current_company.offices.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        respond_to do |format|
          format.html { redirect_to company_offices_path, alert: "Escritório não encontrado." }
          format.json { render json: { error: "Escritório não encontrado" }, status: :not_found }
        end
      end

      # Only allow a list of trusted parameters through.
      def office_params
        params.require(:office).permit(:name, :address, :number, :complement, :neighborhood, :zip_code, :city_id)
      end

      # Retorna a empresa atual do usuário logado
      def current_company
        current_employee.company
      end
  end
end
