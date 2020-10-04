require "application_system_test_case"

class AuthenticationsTest < ApplicationSystemTestCase
  test "valid authentication enables the submit button" do
    alice = users(:alice)

    visit new_authentication_path
    fill_in label(:authentication, :username), with: alice.username
    fill_in label(:authentication, :password), with: "password"

    assert_button submit(:authentication), disabled: false
  end

  test "invalid authentication renders errors" do
    visit new_authentication_path
    click_on submit(:authentication)

    assert_button submit(:authentication), disabled: true
    assert_field label(:authentication, :username), validation_error: "can't be blank"
    assert_field label(:authentication, :password), validation_error: "can't be blank"
  end

  test "invalid inputs re-validate on blur renders errors" do
    visit new_authentication_path
    click_on submit(:authentication)
    fill_in label(:authentication, :username), with: "junk"
    fill_in label(:authentication, :password), with: ""

    assert_button submit(:authentication), disabled: true
    assert_field label(:authentication, :username), valid: true
    assert_field label(:authentication, :password), validation_error: "can't be blank"
    assert_no_field label(:authentication, :username), validation_error: "can't be blank"
  end

  test "invalid authentication falls back to in-Browser validation messages" do
    visit new_authentication_path
    fill_in label(:authentication, :password), with: "junk"
    fill_in label(:authentication, :username), with: ""

    assert_button submit(:authentication), disabled: true
    assert_field label(:authentication, :password), validation_error: "Please lengthen this text to 7 characters or more (you are currently using 4 characters)."
  end
end
