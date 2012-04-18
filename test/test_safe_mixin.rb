# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers.rb'
require 'hacks/safe_mixin'

$orig_append_features_called = false
$orig_extend_object_called = false

module Foo
  def self.append_features(*args)
    $orig_append_features_called = true
  end

  def self.extend_object(*args)
    $orig_extend_object_called = true
  end

  mixin_requires :foo, :bar, 5

  def xyz
    foo
    bar
  end
end

class SafeMixinTest < RUNIT::TestCase
  # TODO: Split this "simple" test into multiple tests
  def test_simple
    assert_exception(TypeError) do
      self.class.__send__(:include, Foo)
    end

    assert_exception(TypeError) do
      self.extend(Foo)
    end

    eval "def foo; end"

    assert_exception(TypeError) do
      self.class.__send__(:include, Foo)
    end

    assert_exception(TypeError) do
      self.extend(Foo)
    end

    eval "def bar; end"

    assert_exception(TypeError) do
      self.class.__send__(:include, Foo)
    end

    assert_exception(TypeError) do
      self.extend(Foo)
    end

    terse_block do
      eval "def bar(a, b, c, d, e); end"
    end

    assert !$orig_append_features_called
    assert !$orig_extend_object_called

    self.class.__send__(:include, Foo)
    assert $orig_append_features_called
    assert !$orig_extend_object_called

    $orig_append_features_called = false
    self.extend(Foo)
    assert !$orig_append_features_called
    assert $orig_extend_object_called
  end
end

exit run_test(SafeMixinTest)

