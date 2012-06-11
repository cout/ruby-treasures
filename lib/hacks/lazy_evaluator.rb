# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'loaders'
requirelocal 'become'
requirelocal 'kernelless_object'

##
# Use a LazyEvaluator to get delayed evaluation of an answer.  The
# answer will be evaluated when any method is called on the
# LazyEvaluator.
#
# The LazyEvaluator will then call the block it was initialized with,
# swap itself (using Object#become) with the return value of the block,
# and then will call the intended method.
#
# The object returned from the block will become the LazyEvaluator.
# This is important, as it means you should never store a reference to
# that object, or you may get unexpected results.
#
# Example:
# <pre>
#   l = LazyEvaluator.new { Object.new }
#   p l #=> #<Object:0x4026bad4>
# </pre>
#
class LazyEvaluator < KernellessObject
  def initialize(&block)
    @p = block
  end

  def method_missing(*args, &block)
    obj = @p.call
    obj.become(self) # self.become doesn't exist
    self.__send__(*args, &block)
  end
end

