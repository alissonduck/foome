class CompanyRegistrationService
  def initialize_registration(params)
    company = Company.new(
      name: params[:name],
      cnpj: params[:cnpj]
    )

    if company.save
      { success: true, company: company }
    else
      { success: false, errors: company.errors.full_messages }
    end
  end

  def update_company_details(company_id, params)
    company = Company.find_by(id: company_id)
    return { success: false, errors: [ "Empresa não encontrada" ] } unless company

    if company.update(
      name: params[:name],
      employee_count: params[:employee_count],
      work_regime: params[:work_regime]
    )
      { success: true, company: company }
    else
      { success: false, errors: company.errors.full_messages }
    end
  end

  def create_office(company_id, params)
    company = Company.find_by(id: company_id)
    return { success: false, errors: [ "Empresa não encontrada" ] } unless company

    office = company.offices.new(
      name: "Escritório Principal",
      city_id: params[:city_id],
      address: params[:address],
      zip_code: params[:zip_code],
      number: params[:number],
      complement: params[:complement],
      neighborhood: params[:neighborhood]
    )

    if office.save
      { success: true, office: office }
    else
      { success: false, errors: office.errors.full_messages }
    end
  end

  def complete_registration(company_id, admin_params)
    company = Company.find_by(id: company_id)
    return { success: false, errors: [ "Empresa não encontrada" ] } unless company

    admin = company.employees.new(
      name: admin_params[:name],
      email: admin_params[:email],
      password: admin_params[:password],
      password_confirmation: admin_params[:password_confirmation],
      role: "admin",
      role_name: "Administrador"
    )

    # Atribuir o escritório principal se existir
    admin.office = company.offices.first if company.offices.any?

    ActiveRecord::Base.transaction do
      if admin.save
        company.update(
          onboarding_completed: true,
          terms_accepted: admin_params[:terms_accepted]
        )

        { success: true, admin: admin, company: company }
      else
        { success: false, errors: admin.errors.full_messages }
      end
    end
  rescue => e
    { success: false, errors: [ e.message ] }
  end
end
