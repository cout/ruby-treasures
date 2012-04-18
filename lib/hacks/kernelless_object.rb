# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'kernelless_object.so'

if false then

##
# A KernellessObject is an object that does not include the Kernel as a
# module.  Currently, it does not define some very basic methods (to_s, nil?,
# etc.), but perhaps it should.
#
class KernellessObject
  ##
  # Same as Kernel#instance_eval
  #
  def __instance_eval__(*args, &block)
  end
end

end
