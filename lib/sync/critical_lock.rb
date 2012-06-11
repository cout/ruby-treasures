# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'thread'

class CriticalLock
  def initialize
  end

  def lock
    Thread.critical = true
  end

  def unlock
    Thread.critical = false
  end

  def try_lock
    lock
  end

  def locked?
    Thread.critical #return
  end

  def synchronize(&block)
    Thread.exclusive(&block)
  end
end

