require "test_helper"

class Company::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get company_sessions_new_url
    assert_response :success
  end
end
