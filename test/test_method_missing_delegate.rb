# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers'
require 'hacks/method_missing_delegate'

class Foo
  def foo
    return 42
  end

  def bar
    yield 1
    yield 2
    yield 3
  end
end

class Bar < MethodMissingDelegateClass(Foo)
  def initialize
    @f = Foo.new
    super(@f)
  end
end

class MethodMissingDelegateTest < RUNIT::TestCase
  def setup
    @b = Bar.new
  end

  def test_simple
    assert_equal 42, @b.foo
  end

  def test_iterator
    a = []
    @b.bar do |x|
      a.push(x)
    end
    assert_equal a.size, 3
    assert_equal a[0], 1
    assert_equal a[1], 2
    assert_equal a[2], 3
  end
end

exit run_test(MethodMissingDelegateTest)
