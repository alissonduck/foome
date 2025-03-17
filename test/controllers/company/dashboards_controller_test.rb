require "test_helper"

class Company::DashboardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company_dashboard = company_dashboards(:one)
  end

  test "should get index" do
    get company_dashboards_url
    assert_response :success
  end

  test "should get new" do
    get new_company_dashboard_url
    assert_response :success
  end

  test "should create company_dashboard" do
    assert_difference("Company::Dashboard.count") do
      post company_dashboards_url, params: { company_dashboard: {} }
    end

    assert_redirected_to company_dashboard_url(Company::Dashboard.last)
  end

  test "should show company_dashboard" do
    get company_dashboard_url(@company_dashboard)
    assert_response :success
  end

  test "should get edit" do
    get edit_company_dashboard_url(@company_dashboard)
    assert_response :success
  end

  test "should update company_dashboard" do
    patch company_dashboard_url(@company_dashboard), params: { company_dashboard: {} }
    assert_redirected_to company_dashboard_url(@company_dashboard)
  end

  test "should destroy company_dashboard" do
    assert_difference("Company::Dashboard.count", -1) do
      delete company_dashboard_url(@company_dashboard)
    end

    assert_redirected_to company_dashboards_url
  end
end
