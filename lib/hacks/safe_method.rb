# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'loaders'
requirelocal 'safe_send'

##
# A SafeMethod is like a Method, but does checking to make sure it is not
# called on an inappropriate (private/protected) method.
#
class SafeMethod
  def initialize(obj, method)
    @obj = obj
    @method = method
  end

  def call(*args, &block)
    safe_send(@obj, @method, *args, &block)
  end

  alias_method :[], :call

  def to_proc
    Proc.new { self.call }
  end

  def arity
    @obj.method(@method).arity
  end
end

##
# Return a new SafeMethod for the given object and method.
#
def safe_method(obj, method)
  SafeMethod.new(obj, method)
end

