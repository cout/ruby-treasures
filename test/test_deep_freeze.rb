# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers'
require 'hacks/deep_freeze'

module ExceptionalEach
  def each
    raise RuntimeError
  end
end

Holder = Struct.new("IntegerHolder", :value)

class X
  include RUNIT::Assert

  attr_reader :x, :y, :arr

  def initialize
    @x = "foo"
    @y = Holder.new(42)
    @arr = ["foo", "bar"]
  end

  def check_invariants
    assert_equal "foo", @x
    assert_equal 42, @y.value
    assert_equal 2, @arr.length
    assert_equal "foo", @arr[0]
    assert_equal "bar", @arr[1]
  end
end

class DeepFreezeTest < RUNIT::TestCase
  def test_deep_freeze
    x = X.new
    x.deep_freeze

    assert x.frozen?
    assert x.x.frozen?
    assert x.y.frozen?
    assert x.arr.frozen?
    assert !x.arr[0].frozen?
    assert !x.arr[1].frozen?

    x.check_invariants
  end

  def test_deep_container_freeze
    x = X.new
    x.deep_freeze(-1, true)

    assert x.frozen?
    assert x.x.frozen?
    assert x.y.frozen?
    assert x.arr.frozen?
    assert x.arr[0].frozen?
    assert x.arr[1].frozen?

    x.check_invariants
  end

  def test_max_depth_1
    x = X.new
    x.deep_freeze(1)

    assert x.frozen?
    assert !x.x.frozen?
    assert !x.y.frozen?
    assert !x.arr.frozen?
    assert !x.arr[0].frozen?
    assert !x.arr[1].frozen?

    x.check_invariants
  end

  def test_max_depth_2
    x = X.new
    x.deep_freeze(2, true)

    assert x.frozen?
    assert x.x.frozen?
    assert x.y.frozen?
    assert x.arr.frozen?
    assert !x.arr[0].frozen?
    assert !x.arr[1].frozen?

    x.check_invariants
  end

  def test_exceptions
    x = X.new
    x.y.extend(ExceptionalEach)
    x.arr[0].freeze
    x.freeze

    assert_exception(RuntimeError) do
      x.deep_freeze(-1, true)
    end

    assert x.frozen?
    assert !x.x.frozen?
    assert !x.y.frozen?
    assert !x.arr.frozen?
    assert x.arr[0].frozen?
    assert !x.arr[1].frozen?
  end
end

exit run_test(DeepFreezeTest)

