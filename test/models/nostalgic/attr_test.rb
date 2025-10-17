require 'test_helper'

module Nostalgic
  class AttrTest < ActiveSupport::TestCase

    def test_nostalgic_model
      assert_nothing_raised do
        Nostalgic::Attr.new
      end
    end

  end
end
