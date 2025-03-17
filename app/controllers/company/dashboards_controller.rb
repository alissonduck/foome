class Company::DashboardsController < ApplicationController
  before_action :set_company_dashboard, only: %i[ show edit update destroy ]

  # GET /company/dashboards or /company/dashboards.json
  def index
    @company_dashboards = Company::Dashboard.all
  end

  # GET /company/dashboards/1 or /company/dashboards/1.json
  def show
  end

  # GET /company/dashboards/new
  def new
    @company_dashboard = Company::Dashboard.new
  end

  # GET /company/dashboards/1/edit
  def edit
  end

  # POST /company/dashboards or /company/dashboards.json
  def create
    @company_dashboard = Company::Dashboard.new(company_dashboard_params)

    respond_to do |format|
      if @company_dashboard.save
        format.html { redirect_to @company_dashboard, notice: "Dashboard was successfully created." }
        format.json { render :show, status: :created, location: @company_dashboard }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @company_dashboard.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /company/dashboards/1 or /company/dashboards/1.json
  def update
    respond_to do |format|
      if @company_dashboard.update(company_dashboard_params)
        format.html { redirect_to @company_dashboard, notice: "Dashboard was successfully updated." }
        format.json { render :show, status: :ok, location: @company_dashboard }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @company_dashboard.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /company/dashboards/1 or /company/dashboards/1.json
  def destroy
    @company_dashboard.destroy!

    respond_to do |format|
      format.html { redirect_to company_dashboards_path, status: :see_other, notice: "Dashboard was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company_dashboard
      @company_dashboard = Company::Dashboard.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def company_dashboard_params
      params.fetch(:company_dashboard, {})
    end
end
