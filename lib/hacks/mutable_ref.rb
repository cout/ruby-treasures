# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'loaders'
requirelocal 'const_method'

class MutableRef
  def initialize(obj)
    @obj = obj
  end

  def method_missing(*message, &block)
    mutable_send(@obj, *message, &block)
  end
end

