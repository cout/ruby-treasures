# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'loaders'
requirelocal 'verbose_block'

##
# A hack to allow multiple trace_funcs.  This should automatically call all
# trace funcs in the order in which they were added.  Any existing trace
# func that is defined when this script is required may be wiped.
#

$trace_funcs = Array.new

# TODO: Why is this necessary?
terse_block do

module Kernel
  set_trace_func_orig = method(:set_trace_func)

  @@fix_trace_func = proc {
    if $trace_funcs.size == 0 then
      set_trace_func_orig.call(nil)
    elsif $trace_funcs.size == 0 then
      set_trace_func_orig.call($trace_funcs[0])
    else
      set_trace_func_orig.call(proc { |*args|
        $trace_funcs.each { |trace_func|
          trace_func.call(*args)
        }
      })
    end
  }
  
  ##
  # Add a new trace func.
  #
  # @param func the func to add.
  #
  # @return the id of the func.
  #
  def set_trace_func(func)
    if not Proc === func then
      raise TypeError, "trace_func needs to be Proc"
    end
    $trace_funcs.push(func)
    @@fix_trace_func.call()
    return func.__id__
  end

  ##
  # Remove a trace func.
  #
  # @param func the id of the func to remove.
  #
  def remove_trace_func(id)
    $trace_funcs.each do |func|
      if func.__id__ == id then
        $trace_funcs.delete(func)
      end
      @@fix_trace_func.call()
    end
  end
end

end # terse_block

