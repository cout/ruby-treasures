# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers.rb'
require 'hacks/const_method'

class Foo
  def initialize
    @x = 42
  end

  def foo
    @x = 1
  end
  const_method :foo

  def bar
    @x = 1
  end

  attr_accessor :x
end

class ConstMethodTest < RUNIT::TestCase

  def test_const_method
    f = Foo.new
    assert_equal 42, f.x
    assert_exception(TypeError) { f.foo }
    assert_equal 42, f.x
    f.bar
    assert_equal 1, f.x

    f.x = 42
    f.freeze
    assert_exception(TypeError) { f.foo }
    assert_equal 42, f.x
    assert_exception(TypeError) { f.bar }
    assert_equal 42, f.x
  end

end

exit run_test(ConstMethodTest)

