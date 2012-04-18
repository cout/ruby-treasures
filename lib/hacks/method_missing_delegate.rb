# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'loaders'
requirelocal 'safe_send'

##
# A class similar to SimpleDelegate, but which uses method_missing.
#
class SimpleMethodMissingDelegate
  def initialize(obj)
    __setobj__(obj)
  end

  def method_missing(*args, &block)
    safe_send(@__MethodMissingDelegateClass_obj__, *args, &block)
  end

  def __getobj__()
    @__MethodMissingDelegateClass_obj__
  end
    
  def __setobj__(obj)
    @__MethodMissingDelegateClass_obj__ = obj
  end

  def to_s()
    @__MethodMissingDelegateClass_obj__.to_s()
  end
end

##
# Create a delegate class that uses method_missing to do its dirty work.  Works
# exactly the same as DelegateClass, but also allows the delegated object to
# change at run-time (in a type-safe manner).
#
# TODO: If a class has one name, then is aliased to another name, and the
# original name is changed to point to a different class, then this will not
# work.
#
# TODO: Constants are not delegated properly.
#
def MethodMissingDelegateClass(klass)
  customer = Class.new(SimpleMethodMissingDelegate)
  customer.class_eval <<-END
    @@__MethodMissingDelegateClass_class__ = #{klass}

    def self.method_missing(*args, &block)
      safe_send(__MethodMissingDelegateClass_class__, *args, &block)
    end

    def __setobj__(obj)
      if @@__MethodMissingDelegateClass_class__ === obj then
        super(obj)
      else
        raise TypeError, "Cannot delegate to a class that is not a " +
                         "\#{@@__MethodMissingDelegateClass_class__}"
      end
    end
  END
  return customer
end

