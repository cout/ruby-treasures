# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'const_helpers.so'

if false then
  # The following methods are implemented in C:

  ##
  # Freeze an object, send it a message (without calling private or protected
  # methods), and then unfreeze the object.
  #
  # @param object the object to send the message to.
  # @param args the message to send.
  # @param block an optional code block to send.
  #
  # @return the return value from the method call.
  #
  def const_send(object, *args, &block)
  end

  ##
  # The same as const_send, but temporarily unfreeze the object instead of
  # temporarily freezing it.
  #
  # THIS METHOD IS DANGEROUS.  If an object was frozen, it was frozen for
  # a reason.  This method should not be called from user code.
  #
  # @param object the object to send the message to.
  # @param args the message to send.
  # @param block an optional code block to send.
  #
  # @return the return value from the method call.
  #
  def mutable_send(object, *args, &block)
  end
end

class Module
  ##
  # Given a list of methods, mark them as const.  Const methods are called
  # using const_send.
  #
  # @param methods a list of methods to mark as const methods.
  #
  def const_method(*methods)
    methods.each do |method|
      self.class_eval <<-END
        ##
        # @ignore
        alias_method :__non_const__#{method}, :#{method}

        ##
        # @ignore
        def #{method}(*args, &block)
          const_send(self, :__non_const__#{method}, *args, &block)
        end
      END
    end
  end
end
