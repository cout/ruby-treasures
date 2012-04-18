# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'loaders'
requirelocal 'call_stack'

##
# A hack to allow easy access to private instance variables.
#
# TODO: I'm not 100% convinced that this works as it should.
# 
# TODO: Private instance variables do not get properly marshalled at the moment.
#
# TODO: In order for cleanup to properly occur, all classes that use
# private instance variables MUST call super() from their initialize method.
#
# Example:
# <pre>
#   class Foo
#     private_instance_var :foo
#
#     def initialize
#       super()
#       set_piv :foo, 42
#     end
# 
#     def bar
#       get_piv :foo
#     end
#   end
#   
#   f = Foo.new
#   p f.bar         #=> 42
# </pre>
#
class Object
  INSTANCE_VARS = Hash.new

  module InstanceVarCleanup
    def initialize(*args, &block)
      super(*args, &block)
      ObjectSpace.define_finalizer(
          self,
          InstanceVarCleanup.cleanup(self.type, self.__id__))
    end

    def self.cleanup(klass, id)
      vars = Object::INSTANCE_VARS[klass]
      return proc {
        vars.each do |symbol, hash|
          hash.delete(id)
        end
      }
    end
  end

  ##
  # Define a new private instance variable in the current class.
  #
  # @param symbol the name of the instance variable
  #
  def self.private_instance_var(symbol)
    if INSTANCE_VARS[self].nil? then
      INSTANCE_VARS[self] = Hash.new
      include InstanceVarCleanup
    end
    if INSTANCE_VARS[self].has_key?(symbol) then
      raise NameError, "private instance variable #{symbol} (class #{self}) " +
                       "already defined"
    end
    INSTANCE_VARS[self][symbol] = Hash.new
  end

  ##
  # Return the private instance variable associated with symbol.
  #
  # @param symbol the name of the private instance variable to return
  #
  # @return the private instance variable
  #
  def get_private_instance_var(symbol)
    Object::INSTANCE_VARS[caller_class()][symbol][self.__id__]
  end

  ##
  # Set the private instance variable associated with symbol.
  #
  # @param symbol the name of the private instance variable to return
  # @param value the new value
  #
  # @return value
  #
  def set_private_instance_var(symbol, value)
    Object::INSTANCE_VARS[caller_class()][symbol][self.__id__] = value
  end

  alias_method :get_piv, :get_private_instance_var
  alias_method :set_piv, :set_private_instance_var
end

