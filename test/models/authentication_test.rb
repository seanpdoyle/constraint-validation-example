require "test_helper"

class AuthenticationTest < ActiveSupport::TestCase
  test ".find when the session has an invalid user_id returns nil" do
    session = { user_id: 0 }

    user = Authentication.find(session)

    assert_nil user
  end

  test ".find when the session is missing a user_id returns nil" do
    session = {}

    user = Authentication.find(session)

    assert_nil user
  end

  test ".find retrieves the User matching user_id" do
    alice = users(:alice)
    session = { user_id: alice.id }

    user = Authentication.find(session)

    assert_equal alice, user
  end

  test "invalid when username is blank" do
    authentication = Authentication.new(username: "")

    valid = authentication.validate

    assert_not valid
    assert_includes authentication.errors, :username
  end

  test "invalid when password is blank" do
    authentication = Authentication.new(password: "")

    valid = authentication.validate

    assert_not valid
    assert_includes authentication.errors, :password
  end

  test "invalid when User does not exist" do
    authentication = Authentication.new(username: "junk", password: "junk")

    valid = authentication.validate

    assert_not valid
    assert_includes authentication.errors, :base
  end

  test "invalid when username and password pairing are incorrect" do
    alice = users(:alice)
    authentication = Authentication.new(username: alice.username, password: "junk")

    valid = authentication.validate

    assert_not valid
    assert_includes authentication.errors, :base
  end

  test "#save does not write to the Session when invalid" do
    session = {}
    authentication = Authentication.new(session: session)

    saved = authentication.save

    assert_not saved
    assert_not_empty authentication.errors
    assert_empty session
  end

  test "#save writes to the Session" do
    alice = users(:alice)
    session = {}
    authentication = Authentication.new(
      username: alice.username,
      password: "password",
      session: session
    )

    saved = authentication.save

    assert saved
    assert_empty authentication.errors
    assert_equal alice.id, session[:user_id]
  end

  test "#destroy removes the user_id from the session" do
    session = { user_id: 1 }
    authentication = Authentication.new(session: session)

    authentication.destroy

    assert_empty session
  end
end
