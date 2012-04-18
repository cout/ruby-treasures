# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
##
# A mixin used by other mixins to extend exceptions
#
module ExceptionExtension
public
  ##
  # When Ruby code calls raise(), the interpreter calls the exception() method
  # on the object passed to raise.  If that object is a Class, then
  # exception() will return a new instance of an exception object; if that
  # object is an Object and not a Class, then exception() will generally
  # return self.
  #
  def exception(mesg=nil)
    message = mesg # set the instance variable "mesg"
    return self
  end

private
  def message=(mesg)
    self.message.replace(mesg)
  end
end

##
# A mixin to add arbitrary user data to an exception
#
# Example:
# <pre>
#   begin
#     raise "Foo!"
#   rescue RuntimeError
#     p $!.message
#     $!.extend(ExceptionData)
#     $!.data = 42
#     raise $!, $!.message, $!.backtrace
#   end
# </pre>
#
module ExceptionData
  attr_accessor :data

  include ExceptionExtension
end

