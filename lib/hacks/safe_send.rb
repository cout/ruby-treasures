# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'loaders'
require 'safe_send.so'

# All these methods are implemented in C:

if false then

##
# Object#send is broken, in that it allows private methods to be called, even
# though they are private.  This method will check for calls to protected
# and private methods to make sure that they are not made; a NameError
# be thrown if they are.
#
# @param object the object to send the message to.
# @param method the method to call on the object.
# @param args the arguments to the method.
# @param block an optional code block to send.
#
# @return the return value from the method call.
#
def safe_send(object, method, *args, &block)
end

end # if false

# The following methods are not implemented in C:

##
# Always send a message to an object, even if the requested method is private
# or protected.  Does not work for secret methods, since they do access
# checking on themselves.
#
# @param object the object to send the message to.
# @param method the method to call on the object.
# @param args the arguments to the method.
# @param an optional code block to send.
#
# @return block the return value from the method call.
#
def evil_send(object, method, *args, &block)
  object.__send__(method, *args, &block)
end

