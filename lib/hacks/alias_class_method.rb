# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
##
# alias_method, except for class methods
#
# @return the return value of alias_method
#
def alias_class_method(new, orig)
  retval = nil
  eval %{
    class << self
      retval =
        ##
        # @ignore
        alias_method :#{new}, :#{orig}
    end
  }
  retval
end
