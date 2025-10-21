require "test_helper"

class RoomTest < ActiveSupport::TestCase
  test "should not save room without creator_nickname" do
    room = Room.new
    assert_not room.save
  end
end
