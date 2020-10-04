require "application_system_test_case"

class AuthenticationsTest < ApplicationSystemTestCase
  test "invalid authentication renders errors" do
    visit new_authentication_path
    click_on submit(:authentication)

    assert_field label(:authentication, :username), described_by: "can't be blank"
    assert_field label(:authentication, :password), described_by: "can't be blank"
  end
end
