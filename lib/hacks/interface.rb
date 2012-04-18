# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
##
# A hack to allow a mixin to be used like Java's "interfaces".
#
# E.g.:
# <pre>
#   module Foo
#     interface_method :foo
#     interface_method :bar
#   end
#   
#   class XYZ
#     def bar
#     end
#   end
#   
#   class Bar < XYZ
#     include Foo
#     def foo
#       puts "foo"
#     end
#   end
#   
#   b = Bar.new
#   assert_object_includes_complete(b, Foo)
# </pre>
#
class Module
public
  ##
  # Determine if a class includes a module, in O(n) time.
  #
  # @return true if the class includes the module, false otherwise.
  #
  def includes_module?(mod)
    return included_modules.index(mod)
  end

private
  ##
  # Declare an abstract method.
  #
  # @param symbol the name of the method.
  #
  def interface_method(symbol)
    self.class_eval %{
      if not defined?(@@__interface_methods__) then
        @@__interface_methods__ = Array.new
      end
      @@__interface_methods__.push(symbol)
    }
  end
end

##
# Determine if a class includes a module, in O(n) time.
#
# @return true if the class includes the module, false otherwise.
#
def assert_class_includes(klass, mod)
  if not klass.includes_module?(mod) then
    raise TypeError, "foo_obj should have the Foo interface"
  end
end

##
# Determine if an object's class includes a module, in O(n) time.
#
# @return true if the object's class includes the module, false otherwise.
#
def assert_object_includes(obj, mod)
  assert_class_includes(obj.type, mod)
end

##
# Determine if a class includes a module and implements all the module's
# abstract methods, in O(n+m) time.
#
# @return true if the class includes the module, false otherwise.
#
def assert_class_includes_complete(klass, mod)
  assert_class_includes(klass, mod)
  imethods = mod.class_eval("@@__interface_methods__")
  imethods.each do |meth|
    if not klass.method_defined?(meth) then
      raise TypeError, "Class #{klass} should have method #{meth} from module #{mod} defined"
    end
  end
end

##
# Determine if an object's class includes a module and implements all the
# module's abstract methods, in O(n+m) time.
#
# @return true if the object's class includes the module, false otherwise.
#
def assert_object_includes_complete(obj, mod)
  assert_class_includes_complete(obj.type, mod)
end

