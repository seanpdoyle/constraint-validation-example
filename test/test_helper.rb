ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  private

  def sign_in_as(user)
    username =
      case user when Symbol then users(user).username
      else user.username
      end

    post authentications_path, params: {
      authentication: {
        username: username,
        password: "password"
      }
    }
  end

  def assert_flash_params(params)
    values_from_flash = flash[:params].slice(*params.keys)

    assert_equal \
      params.with_indifferent_access,
      values_from_flash.with_indifferent_access
  end
end
