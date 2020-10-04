require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  Capybara.modify_selector(:rich_text_area) do
    filter_set(:capybara_accessible_selectors, %i[focused fieldset described_by validation_error])
  end
end
