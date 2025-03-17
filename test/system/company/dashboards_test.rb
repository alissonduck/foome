require "application_system_test_case"

class Company::DashboardsTest < ApplicationSystemTestCase
  setup do
    @company_dashboard = company_dashboards(:one)
  end

  test "visiting the index" do
    visit company_dashboards_url
    assert_selector "h1", text: "Dashboards"
  end

  test "should create dashboard" do
    visit company_dashboards_url
    click_on "New dashboard"

    click_on "Create Dashboard"

    assert_text "Dashboard was successfully created"
    click_on "Back"
  end

  test "should update Dashboard" do
    visit company_dashboard_url(@company_dashboard)
    click_on "Edit this dashboard", match: :first

    click_on "Update Dashboard"

    assert_text "Dashboard was successfully updated"
    click_on "Back"
  end

  test "should destroy Dashboard" do
    visit company_dashboard_url(@company_dashboard)
    click_on "Destroy this dashboard", match: :first

    assert_text "Dashboard was successfully destroyed"
  end
end
