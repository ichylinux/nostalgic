require 'test_helper'

class NostalgicTest < ActiveSupport::TestCase
  def test_that_it_has_a_version_number
    refute_nil ::Nostalgic::VERSION
  end

  def test_it_does_something_useful
    assert_kind_of Module, Nostalgic
  end
end
