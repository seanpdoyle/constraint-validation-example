require "application_system_test_case"

class AuthenticationsTest < ApplicationSystemTestCase
  test "invalid authentication renders errors" do
    visit new_authentication_path
    click_on submit(:authentication)

    assert_field label(:authentication, :username), validation_error: "Please fill out this field."
    assert_field label(:authentication, :password), validation_error: "Please fill out this field."
  end

  test "invalid inputs re-validate on blur renders errors" do
    visit new_authentication_path
    click_on submit(:authentication)
    fill_in label(:authentication, :username), with: "junk"
    fill_in label(:authentication, :password), with: ""

    assert_field label(:authentication, :username), valid: true
    assert_field label(:authentication, :password), validation_error: "Please fill out this field."
    assert_no_field label(:authentication, :username), validation_error: "Please fill out this field."
  end
end
