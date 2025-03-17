require "test_helper"

class Company::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get company_registrations_new_url
    assert_response :success
  end

  test "should get create" do
    get company_registrations_create_url
    assert_response :success
  end

  test "should get step_2" do
    get company_registrations_step_2_url
    assert_response :success
  end

  test "should get save_step_2" do
    get company_registrations_save_step_2_url
    assert_response :success
  end

  test "should get step_3" do
    get company_registrations_step_3_url
    assert_response :success
  end

  test "should get save_step_3" do
    get company_registrations_save_step_3_url
    assert_response :success
  end

  test "should get step_4" do
    get company_registrations_step_4_url
    assert_response :success
  end

  test "should get complete" do
    get company_registrations_complete_url
    assert_response :success
  end
end
