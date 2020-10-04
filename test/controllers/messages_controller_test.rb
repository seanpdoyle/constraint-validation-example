require "test_helper"

class MessagesControllerTest < ActionDispatch::IntegrationTest
  test "#create with invalid parameters redirects to the new action" do
    sign_in_as :alice
    post messages_path, params: {
      message: { content: "" }
    }

    assert_redirected_to messages_url
    assert_flash_params({ message: { content: "" } })
  end

  test "#create clears parameters once successful" do
    sign_in_as :alice
    post messages_path, params: {
      message: { content: "" }
    }
    follow_redirect!
    post messages_path, params: {
      message: { content: "Hello, world" }
    }

    assert_response(:redirect).then { follow_redirect! }
    assert_empty flash
    assert_select "ul" do
      assert_select "li", text: "Hello, world", count: 1
    end
  end

  test "#index when unauthenticated links to the log in page" do
    get messages_path

    assert_response :success
    assert_select "trix-editor", count: 0
    assert_select %(a[href="#{new_authentication_path}"])
  end

  test "#index through a direct authenticated request renders a fresh Message form" do
    sign_in_as :alice
    get messages_path

    assert_response :success
    assert_select "trix-editor#message_content ~ #message_content_validation_message", count: 0
    assert_select "trix-editor#message_content ~ span", count: 0
    assert_select %{trix-editor:not([aria-invalid="true"]):not([aria-describedby])}
  end

  test "#index when redirected with invalid parameters renders errors" do
    sign_in_as :alice
    post messages_path, params: {
      message: { content: "" }
    }

    assert_redirected_to(messages_url).then { follow_redirect! }
    assert_select "trix-editor#message_content ~ #message_content_validation_message", "can't be blank"
    assert_select %{trix-editor[aria-invalid="true"][aria-describedby~="message_content_validation_message"]}
  end
end
