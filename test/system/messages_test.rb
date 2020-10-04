require "application_system_test_case"

class MessagesTest < ApplicationSystemTestCase
  test "invalid messages are rendered as :invalid" do
    sign_in_as :alice
    fill_in_rich_text_area label(:message, :content), with: ""
    click_on submit(:message)

    assert_rich_text_area label(:message, :content), validation_error: "can't be blank"
  end

  private
    def assert_rich_text_area(locator, **options)
      assert_selector :rich_text_area, locator, **options
    end
end
