require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  Capybara.modify_selector(:rich_text_area) do
    filter_set(:capybara_accessible_selectors, %i[focused fieldset described_by validation_error])
  end

  private
    def sign_in_as(user)
      username =
        case user when Symbol then users(user).username
        else user.username
        end

      visit new_authentication_path
      fill_in label(:authentication, :username), with: username
      fill_in label(:authentication, :password), with: "password"
      click_on submit(:authentication)
    end

    def label(i18n_key, attribute)
      I18n.translate(attribute, scope: [:helpers, :label, i18n_key])
    end

    def submit(i18n_key)
      I18n.translate(:create, scope: [:helpers, :submit, i18n_key])
    end
end
