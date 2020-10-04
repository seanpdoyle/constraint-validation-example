require "application_system_test_case"

class MessagesTest < ApplicationSystemTestCase
  test "invalid messages are rendered as :invalid" do
    visit messages_path
    fill_in_rich_text_area label(:message, :content), with: ""
    click_on submit(:message)

    assert_rich_text_area label(:message, :content), validation_error: "can't be blank"
  end

  private
    def assert_rich_text_area(locator, **options)
      assert_selector :rich_text_area, locator, **options
    end

    def label(i18n_key, attribute)
      I18n.translate(attribute, scope: [:helpers, :label, i18n_key])
    end

    def submit(i18n_key)
      I18n.translate(:create, scope: [:helpers, :submit, i18n_key])
    end
end
