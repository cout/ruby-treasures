# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'loaders'
requirelocal 'kernelless_object'

##
# Call the given block once for each object.
#
# Example:
# <pre>
#   class Foo
#     def foo; Kernel.puts "foo!"; end
#     def puts(*args); Kernel.puts 'bar!'; end
#   end
#   
#   f = Foo.new
#   with(f) do
#     foo         #=> foo!
#     puts 'foo'  #=> bar!
#   end
# </pre>
#
# @param objects a list of objects to be processed.
# @param block a block to be executed once for each object.
#
# @return the last value from the last call to instance_eval.
#
def with(*objects, &block)
  objects.each do |object|
    proxy_object = WithDelegate.new(object, self)
    proxy_object.__instance_eval__(&block)
  end
end

##
# A helper class for with().  WithDelegate delegates ALL method calls to
# the object it is initialized with, even calls to the kernel.
#
class WithDelegate < KernellessObject
  def initialize(obj, self_obj)
    @obj = obj
    @self_obj = self_obj
  end

  def method_missing(method, *args, &block)
    if @obj.respond_to?(method)
      @obj.__send__(method, *args, &block)
    else
      @self_obj.__send__(method, *args, &block)
    end
  end
end

