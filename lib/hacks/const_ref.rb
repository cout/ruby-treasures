# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'loaders'
requirelocal 'const_method'

##
# In C, there are two types of constant pointers:
# <ol>
#   <li>A constant pointer, so the pointer cannot change
#   <li>A pointer to a constant; the pointer can change, but the object cannot
#       be changed through this pointer (even though the object itself may not
#       be a constant).
# </ol>
#
# Ruby's constants are like #1, above.
#
# Ruby has frozen objects, but no built-in equivalent to #2.  A Const_Ref is
# a reference to an object that freezes the object before calling methods on
# it, and unfreezes the object when the method returns (if the object was not
# already frozen before the method was called).
#
# This is not quite the same as a pointer to a constant, but is similar.  It
# differs in the following example:
# <ol>
#   <li>A holds a Const_Ref to B
#   <li>C holds a reference to B
#   <li>B holds a reference to C
#   <li>A calls a method on B, which calls a method on C, which modifies B.
# </ol>
#
# This method call will fail in Ruby; it would have succeded in C.
#
class ConstRef
  def initialize(obj)
    @obj = obj
  end

  def method_missing(*message, &block)
    const_send(@obj, *message, &block)
  end
end

