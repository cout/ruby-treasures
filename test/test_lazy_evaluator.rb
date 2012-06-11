# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers.rb'
require 'hacks/lazy_evaluator'

class Foo
  attr_reader :a, :b, :c

  def initialize(a, b, c)
    @a, @b, @c = a, b, c
  end
end

class LazyEvaluatorTest < RUNIT::TestCase
  def test_simple
    l = LazyEvaluator.new { Foo.new(0, 1, 2) }
    assert_equal Foo, l.class
    assert_equal 0, l.a
    assert_equal 1, l.b
    assert_equal 2, l.c
  end
end

exit run_test(LazyEvaluatorTest)

