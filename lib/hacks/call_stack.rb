# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
##
# This is a hack for accessing the call stack.  It uses set_trace_func, so
# using this hack may degrade performance.  The result will be a global
# variable $call_stack, which is an array containing information about the
# caller.  Each element of the array is itself an array containing the same
# information as would be returned by set_trace_func.  The current call
# information is stored in $current_call.
#
# TODO: I need some good tests for this.
#
# Eg.:
# <pre>
#   def foo; eval("x = 42", $call_stack[1][4]); end
#   def bar; foo; end
#   x = nil
#   bar
#   puts x
# </pre>
#

require 'loaders'
requirelocal 'fix_trace_func'
require 'rbconfig'

if Config::CONFIG['MAJOR'].to_i == 1 and Config::CONFIG['MINOR'].to_i < 7 then
  # TODO: Figure out why this doesn't work in 1.7
  require 'call_stack.so'
else
  # Here's a pure ruby implementation:
  $call_stack = []
  set_trace_func(proc {|*args|
    case args[0]
      when "call"
        $call_stack.unshift($current_call)
      when "return"
        # If we get an exception, we should still get the normal sequence of
        # "return" messages.
        $call_stack.shift()
    end
    $current_call = args
  })
end

if false then

  ##
  # The type of $call_stack is a CallStack.  It is a singleton class, and
  # cannot be instantiated.
  #
  class CallStack
    ##
    # Find $current_call for index+1 levels above the current one.
    #
    # @return the requested value.
    # 
    def [](index)
    end

    ##
    # Return a copy of the call stack as an array.
    # 
    # The current call stack as an array.
    #
    def to_a()
    end
  end

end # if false

##
# Return the file of the caller
#
# @param level the level of the caller you want to query
#
def caller_file(level = 0)
  $call_stack[level.succ][1]
end

##
# Return the line of the caller
#
# @param level the level of the caller you want to query
#
def caller_lineno(level = 0)
  $call_stack[level.succ][2]
end

##
# Return the function the caller was in
#
# @param level the level of the caller you want to query
#
def caller_func(level = 0)
  $call_stack[level.succ][3]
end

##
# Return the caller's binding
#
# @param level the level of the caller who's binding you want
#
def caller_binding(level = 0)
  $call_stack[level.succ][4]
end

##
# Return the class of the caller
#
# @param level the level of the caller who's class you want
#
def caller_class(level = 0)
  $call_stack[level.succ][5]
end

##
# Return the object ("self") of the caller
#
# @param level the level of the caller who's "self" you want
#
def caller_self(level = 0)
  eval("self", $call_stack[level.succ][4])
end

