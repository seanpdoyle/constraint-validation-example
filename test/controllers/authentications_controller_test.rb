require "test_helper"

class AuthenticationsControllerTest < ActionDispatch::IntegrationTest
  test "#new redirects to messages#index when already authenticated" do
    sign_in_as :alice
    get new_authentication_path

    assert_redirected_to messages_url
  end

  test "#new renders a fresh Authentication form" do
    get new_authentication_path

    assert_response :success
    assert_select "input:not([aria-invalid]):not([aria-describedby])#authentication_username ~ span", count: 0
    assert_select "input:not([aria-invalid]):not([aria-describedby])#authentication_password ~ span", count: 0
  end

  test "#create with a valid username/password pairing writes to the session" do
    alice = users(:alice)

    sign_in_as alice

    assert_redirected_to messages_url
    assert_equal alice.id, session[:user_id]
  end

  test "#create with empty fields redirects with errors" do
    alice = users(:alice)

    post authentications_path, params: {
      authentication: {
        username: "",
        password: "",
      }
    }

    assert_redirected_to(new_authentication_url).then { follow_redirect! }
    assert_flash_params({ authentication: { username: "" } })
    assert_nil session[:user_id]
    assert_select "input#authentication_username ~ #authentication_username_validation_message", text: "can't be blank"
    assert_select %(input[type="text"][aria-invalid="true"][aria-describedby~="authentication_username_validation_message"])
    assert_select "input#authentication_password ~ #authentication_password_validation_message", text: "can't be blank"
    assert_select %(input[type="password"][aria-invalid="true"][aria-describedby~="authentication_password_validation_message"])
  end

  test "#create with an invalid username/password pairing redirects with errors" do
    alice = users(:alice)

    post authentications_path, params: {
      authentication: {
        username: alice.username,
        password: "junk",
      }
    }

    assert_redirected_to(new_authentication_url).then { follow_redirect! }
    assert_flash_params({ authentication: { username: alice.username } })
    assert_nil session[:user_id]
    assert_select %(p[aria-live="assertive"][id="authentication_base_validation_message"]), text: "is invalid", count: 1
    assert_select %(input[type="text"][value="#{alice.username}"])
    assert_select %(input[type="password"]:not([value]))
  end

  test "#destroy logs the User out" do
    sign_in_as :alice

    delete authentication_path

    assert_redirected_to messages_url
    assert_nil session[:user_id]
  end
end
