# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers.rb'
require 'hacks/interface'

module Foo
  interface_method :foo
  interface_method :bar
end

class XYZ
  def bar
  end
end

class Bar < XYZ
  include Foo
  def foo
  end
end

class Bar2 < XYZ
  include Foo
end

class Bar3
  def foo
  end

  def bar
  end
end

class InterfaceTest < RUNIT::TestCase
  def test_simple
    b = Bar.new
    assert_object_includes_complete(b, Foo)

    b2 = Bar2.new
    assert_exception(TypeError) do
      assert_object_includes_complete(b2, Foo)
    end

    b3 = Bar3.new
    assert_exception(TypeError) do
      assert_object_includes_complete(b3, Foo)
    end
  end
end

exit run_test(InterfaceTest)

