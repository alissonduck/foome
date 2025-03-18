class OfficesController < ApplicationController
  before_action :set_office, only: %i[ show edit update destroy ]

  # GET /offices or /offices.json
  def index
    @offices = OfficeService.list_offices
  end

  # GET /offices/1 or /offices/1.json
  def show
  end

  # GET /offices/new
  def new
    @office = Office.new
  end

  # GET /offices/1/edit
  def edit
  end

  # POST /offices or /offices.json
  def create
    result = OfficeService.create_office(office_params)
    @office = result[:office]

    respond_to do |format|
      if result[:success]
        format.html { redirect_to @office, notice: "Escritório criado com sucesso." }
        format.json { render :show, status: :created, location: @office }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @office.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /offices/1 or /offices/1.json
  def update
    result = OfficeService.update_office(@office, office_params)

    respond_to do |format|
      if result[:success]
        format.html { redirect_to @office, notice: "Escritório atualizado com sucesso." }
        format.json { render :show, status: :ok, location: @office }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @office.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offices/1 or /offices/1.json
  def destroy
    result = OfficeService.destroy_office(@office)

    respond_to do |format|
      if result[:success]
        format.html { redirect_to offices_path, status: :see_other, notice: "Escritório removido com sucesso." }
        format.json { head :no_content }
      else
        format.html { redirect_to @office, alert: "Erro ao remover escritório: #{ErrorHandlerService.format_operation_errors(result)}" }
        format.json { render json: result[:errors], status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_office
      @office = OfficeService.find_office(params[:id])
    rescue ActiveRecord::RecordNotFound
      respond_to do |format|
        format.html { redirect_to offices_path, alert: "Escritório não encontrado." }
        format.json { render json: { error: "Escritório não encontrado" }, status: :not_found }
      end
    end

    # Only allow a list of trusted parameters through.
    def office_params
      params.require(:office).permit(:company_id, :city_id, :name, :address, :zip_code, :number, :complement, :neighborhood, :google_infos, :active)
    end
end
