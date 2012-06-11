# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
##
# Include this module to disable copying (dup/clone).
#
module NotCopyable
  def clone
    raise TypeError, "Object not copyable"
  end

  def dup
    raise TypeError, "Object not copyable"
  end
end

