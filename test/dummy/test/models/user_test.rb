require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def test_tel
    assert @user = User.first
    assert_equal '222-123-4567', @user.tel

    assert_equal '111-123-4567', @user.tel_at(Date.today - 1.day)
    assert_equal '222-123-4567', @user.tel_at(Date.today)
    assert_equal '333-123-4567', @user.tel_at(Date.today + 1.day)
  end
end
