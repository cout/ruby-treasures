# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
class Object
  if not respond_to?(:object_id) then
    ##
    # Define object_id on versions of Ruby that don't have it
    def object_id
      return id
    end
  end

end

