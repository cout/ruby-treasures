# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers.rb'
require 'hacks/override_method'

class OverrideMethodTest < RUNIT::TestCase
  def foo
    assert_equal 2, @level
    @level += 1
  end

  override_method :foo do
    def foo
      assert_equal 1, @level
      @level += 1
      super()
    end
  end

  override_method :foo do
    def foo
      p @level
      assert_equal 0, @level
      @level += 1
      super()
    end
  end

  def test_simple
    @level = 0
    p @level
    foo()
    assert_equal 3, @level
  end
end

exit run_test(OverrideMethodTest)

