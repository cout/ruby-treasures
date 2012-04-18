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
  # Freeze a list of objects, yield the list to the given block, and unfreeze
  # each of the objects that was frozen (will not unfreeze an object that was
  # already frozen).
  #
  # @param arr the list of objects to freeze
  # @param block the block to call
  #
  # @return the value returned from calling the block
  #
  def const_var(*args, &block)
  end
end

