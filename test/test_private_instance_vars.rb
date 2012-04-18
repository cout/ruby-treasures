# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers'
require 'hacks/private_instance_vars.rb'
requirelocal 'bad_method_call'

class Foo
  private_instance_var :foo

  def initialize(x)
    super()
    set_piv :foo, x
  end

  def bar
    get_piv :foo
  end
end


class PrivateClassVarsTest < RUNIT::TestCase
  def test_simple
    f = Foo.new(42)
    assert_equal 42, f.bar
    assert_exception(BadMethodCallError) do
      f.foo
    end
  end

  def test_simple_cleanup
    # This test MUST come AFTER test_simple
    GC.start
    assert_equal 0, INSTANCE_VARS[Foo][:foo].size
  end
end

exit run_test(PrivateClassVarsTest)

