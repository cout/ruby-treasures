# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers'
require 'hacks/to_proc'

class Foo
  attr_reader :foo

  def initialize
    @foo = 0
  end

  def call(x)
    @foo = x
  end

  include ConvertibleToProc
end

class ToProcTest < RUNIT::TestCase
  def test_type
    f = Foo.new
    p = f.to_proc
    assert_equal Proc, p.type
  end

  def test_call
    f = Foo.new
    p = f.to_proc
    assert_equal 0, f.foo
    p.call(42)
    assert_equal 42, f.foo
  end
end

exit run_test(ToProcTest)

