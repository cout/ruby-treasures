# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'loaders'
requirelocal 'safe_mixin'

##
# Mix this into a class that responds to call() to get a to_proc method to
# convert the object to a Proc object.  You can use the resulting Proc with
# methods that are expecting a Proc object (such as set_trace_func).
#
# TODO: Is it possible to send a block to the Proc?
#
module ConvertibleToProc
  mixin_requires :call

  def to_proc()
    return proc { |*args| self.call(*args) }
  end
end

