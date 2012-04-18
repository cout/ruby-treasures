# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'super_method.so'

# the following methods are implemented in C:

if false then

##
# A hack to be able to call methods in any superclass, not just the immediate
# superclass.
#
class Object
private
  ##
  # Return a method object from parent class (or module)
  #
  # @param klass the superclass the method is in
  # @param method_name the name of the method to get a Method object for
  #
  # @return a Method object, bound to self
  #
  def super_method(klass, method_name)
  end

  ##
  # Call a method in a parent class.  Equivalent to:
  # <pre>
  #   super_method(klass, method_name).call(*args, &block)
  # </pre>
  #
  def super_call(klass, method_name, *args, &block)
  end
end

end # if false

