# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
##
# An implementation of deep_copy, based on [ruby-talk:03156].
#
# TODO: Using Marshal.load/Marshal.dump is slow, and doesn't work with
# all objects.  Using each and/or each_instance_variable would be a
# better solution, but would make reconstructing the object more
# difficult.
#
class Object
  def deep_copy
    Marshal.load(Marshal.dump(self))
  end
end

