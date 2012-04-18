# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers'
require 'super_method'

class Foo
  def foo
    return "Foo#foo"
  end
end

class Bar < Foo
  def foo
    return "Bar#foo"
  end
end

class SuperMethodTest < RUNIT::TestCase
  def test_super_method
    b = Bar.new
    assert_equal "Bar#foo", b.foo
    assert_equal "Bar#foo", b.instance_eval { super_method(Bar, :foo).call }
    assert_equal "Foo#foo", b.instance_eval { super_method(Foo, :foo).call }
  end

  def test_super_call
    b = Bar.new
    assert_equal "Bar#foo", b.foo
    assert_equal "Bar#foo", b.instance_eval { super_call(Bar, :foo) }
    assert_equal "Foo#foo", b.instance_eval { super_call(Foo, :foo) }
  end
end

exit run_test(SuperMethodTest)

