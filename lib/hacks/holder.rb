# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'loaders'
requirelocal 'method_missing_delegate'

##
# Create a Holder class, to allow non-reference objects to be returned.
# In Scheme, this might be known as a "Box".
#
# Example:
# <pre>
#   FixnumHolder = Holder(Fixnum)
#   def foo(inout)
#       inout.value = 42
#   end
#   a = FixnumHolder.new(10)
#   puts a                      #=> 10
#   foo(a)
#   puts a                      #=> 42
#   puts a + 5                  #=> 47
# </pre>
#
# @param klass the type to generate a holder class for.
#
# @return a new class that can be used as a holder.
#
def Holder(klass)
  customer = Class.new(MethodMissingDelegateClass(klass))

=begin
  class Holder(klass)
=end
  customer.class_eval %{
    def initialize(i)
      @i = i
      super(@i)
    end
    
    def value=(other)
      if self.type === other then
        __setobj__(other.i)
        @i = other.i
      else
        __setobj__(other)
        @i = other
      end
    end
    
    def value
      @i
    end

    def to_s
      @i.to_s
    end

    def ==(other)
      @i == other
    end
  }
=begin
  end
=end

  return customer
end

