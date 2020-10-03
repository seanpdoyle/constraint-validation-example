require "test_helper"

class MessageTest < ActiveSupport::TestCase
  test "invalid when content is missing" do
    message = Message.new

    valid = message.validate

    assert_not valid
    assert_includes message.errors, :content
  end
end
