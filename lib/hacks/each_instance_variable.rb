# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'each_instance_variable.so'

# The following methods are implemented in C:
if false then

  class Object
  private
    ##
    # Iterate over every instance variable in the given object, yielding
    # [ name, obj ], where name is the Symbol representing the name of
    # the instance variable, and obj is the instance variable itself.
    #
    # This is useful for operations such as deep freeze and deep copy.
    # It can also come in handy for writing custom marshallers.  A less
    # common use would be to access instance variables whose name do not
    # begin with the @ character (such as the Exception class's mesg
    # variable).
    #
    def each_instance_variable
    end
  end
end

