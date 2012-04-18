# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers.rb'
require 'hacks/call_stack'

def foo
  eval("y = x", caller_binding(1))
  $call_stack.to_a # make sure that the reversal was done correctly
  eval("x = 42", caller_binding(1))
end

def bar
  foo
end

def xyz
  x = nil
  bar
  return x
end

class CallStackTest < RUNIT::TestCase

  def test_simple
    assert_equal 42, xyz()
  end

end

exit run_test(CallStackTest)

