# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers.rb'
require 'hacks/with'

class Foo
  def foo
    return 42
  end
end

class WithTest < RUNIT::TestCase
  def bar
    @bar_called = true
  end
  
  def test_simple
    @bar_called = false
    f = Foo.new
    with(f) do
      bar
      assert_equal foo, 42
    end
    assert @bar_called
  end
end

exit run_test(WithTest)

