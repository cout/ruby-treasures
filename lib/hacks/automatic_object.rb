# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'weakref'

##
# Include this module in a class to force all instances of that class
# to be temporary objects that will be destructed when they go out of
# scope.
#
# The class's initialize and finalize instance methods will be called
# when the object is created and when it goes out of scope, respectively.
# Including this module will make the class's "new" method private, and
# will add a new class method called "create" that can be used to create
# instances of the object.  A call to create will yield a weak reference
# to the object.
#
# Note that the object itself may not actually be destroyed until the
# garbage collector is invoked.  The user can keep a reference to the
# object after the block exits by calling __getobj__ on the reference
# from inside the block and returning it, but this is not a recommended
# practice, since the object will be in a half-dead state.
#
# Example:
# <pre>
#   class Foo
#     include AutomaticObject
#     def initialize; puts "initialize"; end
#     def finalize; puts "finalize"; end
#   end
#
#   Foo.create do |f|       #=> initialize
#     # ...
#   end                     #=> finalize
# </pre>
#
module AutomaticObject
  def self.extend_object(obj)
    raise "Unable to extend with AutomaticObject"
  end

  def self.append_features(mod)
    mod.instance_eval do
      def self.create(*args, &block)
        obj = new(*args)
        begin
          yield WeakRef.new(obj)
        ensure
          obj.finalize
          id = WeakRef::ID_MAP.delete(obj.__id__)
          WeakRef::ID_REV_MAP.delete(id)
        end
      end

      private_class_method :new
    end
  end
end

