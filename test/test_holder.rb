# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers.rb'
require 'hacks/holder'

class HolderTest < RUNIT::TestCase

  FixnumHolder = Holder(Fixnum)

  def foo(inout)
    inout.value = 42
  end

  def test_simple
    a = FixnumHolder.new(10)
    assert_equal a, 10
    foo(a)
    assert_equal a, 42
    assert_equal a + 5, 47
    assert_equal FixnumHolder, a.type
  end

end

exit run_test(HolderTest)

