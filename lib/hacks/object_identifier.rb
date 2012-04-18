# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
##
# Return a string formatted the same way Ruby prints object ID's when
# inspecting objects.
#
def object_identifier(obj)
  return "0x#{'%x'%(obj.id)}"
end

