# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'loaders'
requirelocal 'call_stack'

##
# A hack to allow easy access to private class variables.
#
# TODO: I'm not 100% convinced that this works as it should.
#
# Example:
# <pre>
#   class Foo
#     private_class_var :foo
#
#     self.foo = 1
#
#     def xyz
#       # Don't use self.type.foo here, otherwise you will get the derived
#       # class's foo.
#       Foo.foo
#     end
#   end
#
#   f = Foo.new
#   p f.xyz             #=> 1
#   p Foo.foo           #=> (NameError)
# </pre>
#
class Module
  ##
  # Define a new private class variable.  The class variable will be
  # accessible from the class with "self.symbol" and from instances of the
  # class with "Class.symbol".
  #
  # @param symbol the name of the private class variable.
  # @param initial_value the initial value for the variable.
  # 
  def private_class_var(symbol, initial_value=nil)
    access_level_check = proc { |meth| %{
      obj = caller_class()
      obj_self = caller_self()
      if not #{self} == obj and
         not #{self} == obj_self and
         not #{self} === obj_self then
        raise(
          NameError,
          "private method `#{meth}' called for #{self}:#{type}",
          caller)
      end
    }}

    self.class_eval <<-END
      class << self
        def #{symbol}()
          #{access_level_check.call(symbol)}
          @#{symbol}
        end
      end
    END

    self.class_eval <<-END
      class << self
        def #{symbol}=(rhs)
          #{access_level_check.call(symbol.to_s + '=')}
          @#{symbol} =  rhs
        end
      end
    END

    self.__send__("#{symbol}=", initial_value)
  end

  def private_class_var_defined?(symbol)
    # TODO: Surely there is a better way to do this...
    begin
      eval(symbol.to_s)
      return true
    rescue NameError
      return false
    end
  end
end

