# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers'
require 'hacks/refcount'

class Foo
  def initialize
    ObjectSpace.define_finalizer(self, self.class.method(:finalize).to_proc)
  end

  def foo
    return 42
  end

  def finalize
    $finalize_called = true
  end

  def self.finalize(id)
    $finalizer_called = true
  end
end

Bar = Refcounted_Class(Foo)

class RefcountTest < RUNIT::TestCase

  def main
    b = Bar.new
    b.refer do
      assert_equal 42, b.foo()
    end
    assert_equal true, $finalize_called
    assert_equal false, $finalizer_called
  end

  def test_simple
    $finalize_called = false
    $finalizer_called = false
    main()
    assert_equal true, $finalize_called
    assert_equal false, $finalizer_called

    GC.start
    assert_equal true, $finalizer_called
  end
end

exit run_test(RefcountTest)

