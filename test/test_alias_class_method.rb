# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers.rb'
require 'hacks/alias_class_method'

$foo_called = false

class Foo
  def self.foo
    $foo_called = true
  end

  alias_class_method :bar, :foo
end

class AliasClassMethodTest < RUNIT::TestCase
  def test_simple
    Foo::bar()
    assert $foo_called
  end
end

exit run_test(AliasClassMethodTest)

