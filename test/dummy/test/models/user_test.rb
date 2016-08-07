require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def test_tel
    assert @user = User.first
    assert_equal '222-123-4567', @user.tel

    assert_raise ArgumentError do
      @user.tel_at(nil)
    end

    assert_equal '111-123-4567', @user.tel_at(Date.today - 1.day)
    assert_equal '222-123-4567', @user.tel_at(Date.today)
    assert_equal '333-123-4567', @user.tel_at(Date.today + 1.day)
  end

  def test_save_tel
    today = Date.today
    assert @user = User.first
    assert_not_equal '444-123-4567', @user.tel
    assert_not_equal '444-123-4567', @user.tel_at(today)

    @user.tel = '444-123-4567'
    @user.tel_effective_at = today
    assert @user.save
    assert_equal '444-123-4567', @user.tel
    assert_equal '444-123-4567', @user.tel_at(today)

    @user.tel = '555-123-4567'
    @user.tel_effective_at = today + 2.days
    assert @user.save
    assert_equal '555-123-4567', @user.tel
    assert_equal '444-123-4567', @user.tel_at(today)
    assert_equal '333-123-4567', @user.tel_at(today + 1.day)
    assert_equal '555-123-4567', @user.tel_at(today + 2.day)
  end
end
