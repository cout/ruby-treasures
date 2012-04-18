# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'loaders'
requirelocal 'call_stack'
requirelocal 'method_missing_delegate'

WRAPPED_CLASSES = Hash.new

##
# Enable the "finalize" method for the given class.  Normally, when a
# finalizer is called, the object has already been garbage collected.  This
# will create a proxy object that keeps the object around so that the
# object's "finalize" method can be called; the object is then garbage
# collected.
#
# The resulting proxy class will be frozen, since adding new methods to the
# proxy class would probably not have the desired effect.  The original
# class will have the name Class_Finalize_Wrapped, where Class is that name
# of the original class.
#
# TODO: Because this class uses method_missing_delegate, constants may not
# be properly delegated.
#
# Example:
# <pre>
#   class Foo
#     def initialize
#       puts "initialize"
#     end
#   
#     def finalize
#       puts "finalize"
#     end
#   end
#   enable_finalize(:Foo)
#   
#   def foo
#     f = Foo.new
#   end
#   
#   foo             #=> initialize
#   GC.start        #=> finalize
# </pre>
# 
def enable_finalize(symbol)
  wrapped = "#{symbol}_Finalize_Wrapped"
  eval(%~
    #{wrapped} = #{symbol}
    if self.class == Object
      Object.__send__(:remove_const, :#{symbol})
    else
      remove_const(:#{symbol})
    end
    name = Module.nesting.join("::") + "::" + "#{wrapped}"
    class #{symbol} < MethodMissingDelegateClass(name)
      def initialize(*args, &block)
        wrapped = #{wrapped}.new(*args, &block)
        WRAPPED_CLASSES[self.__id__] = wrapped
        super(wrapped)
        ObjectSpace.define_finalizer self, self.class.method(:finalizer).to_proc
      end
      def self.finalizer(id)
        WRAPPED_CLASSES[id].finalize()
        WRAPPED_CLASSES.delete(id)
        GC.start
      end
    end
    #{symbol}.freeze
  ~, caller_binding())
end

