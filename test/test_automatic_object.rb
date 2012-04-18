# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers'
require 'hacks/automatic_object'

class Foo
  include AutomaticObject

  def initialize
    $initialized = true
  end

  def finalize
    $finalized = true
  end
end

class MyException < RuntimeError
  attr_reader :x

  def initialize(x)
    @x = x
  end
end

class AutomaticObjectTest < RUNIT::TestCase
  def test_simple
    begin
      $initialized = false
      $finalized = false

      Foo.create do |f|
        assert_equal true, $initialized
        assert_equal false, $finalized
        assert_equal WeakRef, f.type
        assert_equal Foo, f.__getobj__.type
        assert_equal true, f.weakref_alive?
        raise MyException.new(f)
      end
    rescue MyException
      assert_equal true, $finalized
      f = $!.x
      assert_equal false, f.weakref_alive?
    end
  end
end

exit run_test(AutomaticObjectTest)

