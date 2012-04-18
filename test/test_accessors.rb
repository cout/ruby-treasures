# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers.rb'
require 'hacks/accessors'

$foo_called = false

class Foo
  attr_class_reader :foo
  attr_class_writer :bar
  attr_class_accessor :xyz

  def get_bar
    @@bar
  end

  def set_foo(f)
    @@foo = f
  end
end

class AliasClassMethodTest < RUNIT::TestCase
  def test_simple
    f = Foo.new

    f.set_foo(42)
    assert_equal 42, Foo.foo

    Foo.bar = 0
    assert_equal 0, f.get_bar

    Foo.xyz = :foo
    assert_equal :foo, Foo.xyz
  end
end

exit run_test(AliasClassMethodTest)

