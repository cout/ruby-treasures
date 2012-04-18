# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers'
require 'hacks/private_class_vars.rb'

class Foo
  private_class_var :foo

  self.foo = 1

  def xyz
    # Don't use self.type.foo here, otherwise you will get the derived
    # class's foo.
    Foo.foo
  end
end

class PrivateClassVarsTest < RUNIT::TestCase
  def test_simple
    f = Foo.new
    assert_equal 1, f.xyz
    assert_exception(NameError) do
      Foo.foo
    end
  end
end

exit run_test(PrivateClassVarsTest)

