# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers.rb'
require 'hacks/base_class_intercept'

class Foo
  def foo
    return self.type.new
  end
end

class Bar < Foo
  base_class_intercept :foo
end

class BaseClassInterceptTest < RUNIT::TestCase

  def test_simple
    b = Bar.new
    assert_equal Bar, b.foo.type
  end

end

exit run_test(BaseClassInterceptTest)

