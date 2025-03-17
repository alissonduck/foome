require "application_system_test_case"

class OfficesTest < ApplicationSystemTestCase
  setup do
    @office = offices(:one)
  end

  test "visiting the index" do
    visit offices_url
    assert_selector "h1", text: "Offices"
  end

  test "should create office" do
    visit offices_url
    click_on "New office"

    check "Active" if @office.active
    fill_in "Address", with: @office.address
    fill_in "City", with: @office.city_id
    fill_in "Company", with: @office.company_id
    fill_in "Complement", with: @office.complement
    fill_in "Google infos", with: @office.google_infos
    fill_in "Name", with: @office.name
    fill_in "Neighborhood", with: @office.neighborhood
    fill_in "Number", with: @office.number
    fill_in "Zip code", with: @office.zip_code
    click_on "Create Office"

    assert_text "Office was successfully created"
    click_on "Back"
  end

  test "should update Office" do
    visit office_url(@office)
    click_on "Edit this office", match: :first

    check "Active" if @office.active
    fill_in "Address", with: @office.address
    fill_in "City", with: @office.city_id
    fill_in "Company", with: @office.company_id
    fill_in "Complement", with: @office.complement
    fill_in "Google infos", with: @office.google_infos
    fill_in "Name", with: @office.name
    fill_in "Neighborhood", with: @office.neighborhood
    fill_in "Number", with: @office.number
    fill_in "Zip code", with: @office.zip_code
    click_on "Update Office"

    assert_text "Office was successfully updated"
    click_on "Back"
  end

  test "should destroy Office" do
    visit office_url(@office)
    click_on "Destroy this office", match: :first

    assert_text "Office was successfully destroyed"
  end
end
