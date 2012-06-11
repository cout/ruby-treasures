# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers'
require 'not_copyable'

class Foo
  include NotCopyable
end

class Bar < Foo
end

class Foo2
end

class NotCopyableTest < RUNIT::TestCase
  def test_dup
    f = Foo.new
    assert_exception(TypeError) do
      g = f.dup
    end
  end

  def test_dup_derived
    f = Bar.new
    assert_exception(TypeError) do
      g = f.dup
    end
  end

  def test_dup_okay
    f = Foo2.new
    g = f.dup
  end

  def test_clone
    f = Foo.new
    assert_exception(TypeError) do
      g = f.clone
    end
  end

  def test_clone_derived
    f = Bar.new
    assert_exception(TypeError) do
      g = f.clone
    end
  end

  def test_clone_okay
    f = Foo2.new
    g = f.clone
  end
end

exit run_test(NotCopyableTest)

