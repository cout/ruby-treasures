# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'loaders'
requirelocal 'alias_class_method'
requirelocal 'object_identifier'

##
# A hack that allows mixins to only be mixed in to classes that have the
# specified methods defined.  Note that this requires that the 'include' appear
# at the end of the class definition (after all the methods have been defined).
#
# Example:
# <pre>
#   module Foo
#     mixin_requires :foo, :bar
#     
#     def xyz
#       # If foo and bar are not defined in the derived class, then this will
#       # raise an exception, so it's best to know that this won't work at
#       # load-time.
#       foo
#       bar
#     end
#   end
#   
#   class Bar
#     def foo
#       puts "foo"
#     end
#   
#     def bar
#       puts "bar"
#     end
#   
#     # This must come last, because foo and bar must be defined before
#     # including Foo.  If they are not defined, then an exception will be
#     # thrown.
#     include Foo
#   end
# </pre>
#
class Module
  ##
  # Require that the class/module that a mixin is being included in MUST define
  # certain methods.
  #
  # @param args A list of Symbols and Integers.  When a Sybmbol, indicates
  # the given method must be defined.  When an Integer, indicates the desired
  # arity of the method indicated by the previous Symbol.
  #
  def mixin_requires(*args)
    # TODO: Is there any way to do this but still allow 'include' to occur at the
    # top of the class definition?
    #
    # TODO: One way to do this is to disallow instantiation of the object unless
    # the specific methods are defined.  This is how C++ does it; the advantage
    # is that virtual functions in the base class can be implemented in anywhere
    # in the hierarchy.  A way around this for now is to declare a "stub" in the
    # base class for any mixins that use mixin_requires, though this has its own
    # set of problems.

    if self.type == Class then
      raise TypeError, "safe_mixin() called for Class"
    end

    methods = Array.new
    arities = Hash.new
    last_method = nil
    args.each do |arg|
      case arg
      when Symbol
        methods.push(arg)
        last_method = arg
      when Integer
        raise ArgumentError, "Symbol expected" if last_method.nil?
        if arg < 0 then
          raise ArgumentError, "Desired arity must be non-negative"
        end
        arities[last_method] = arg
        last_method = nil
      else
        raise TypeError, "Unexpected: #{method.type}"
      end
    end

    module_class = class <<self; self; end
    orig_module = self

    module_class.instance_eval do
      # append_features
      old_append_features = orig_module.method(:append_features)
      define_method :append_features do |other|
        methods.each do |method|
          if not other.method_defined?(method) then
            raise TypeError, "Module #{other} does not define method #{method}"
          end
        end

        arities.each do |method, arity|
          actual_arity = other.instance_method(method).arity
          if not arity_matches(actual_arity, arity) then
            raise TypeError, "Method #{other}##{method} has incorrect arity " \
                             "#{actual_arity} (should be #{arity})"
          end
        end
        old_append_features.call(other)
      end

      # extend_object
      old_extend_object = orig_module.method(:extend_object)
      define_method :extend_object do |obj|
        methods.each do |method|
          if not obj.respond_to?(method, true) then
            raise TypeError, "#{object_identifier(obj)} does not respond " \
                             "to method #{method}"
          end
        end

        arities.each do |method, arity|
          actual_arity = obj.method(method).arity
          if not arity_matches(actual_arity, arity) then
            raise TypeError, "Method #{method} of #{object_identifier(obj)} " \
                             "has incorrect arity #{actual_arity} " \
                             "(should be #{arity})"
          end
        end
        old_extend_object.call(obj)
      end
    end
  end

  def arity_matches(actual_arity, desired_arity)
    # if the arity is non-negative, it is the number of required arguments.  if
    # the arity is negative, the number of required arguments is (1-arity).
    required_args = actual_arity < 0 ? (1-actual_arity) : actual_arity
    desired_arity == required_args #return
  end
end

