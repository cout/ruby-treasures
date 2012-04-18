# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'thread'

class WaitQueue
  def initialize
    @queue = Array.new
  end

  def wait(mutex)
    cond = ConditionVariable.new
    @queue.push(cond)
    cond.wait(mutex)
  end

  def hook(mutex)
    cond = @queue.last
    cond.wait(mutex)
  end

  def post
    cond = @queue.shift
    cond.broadcast if cond
  end

  def size
    return @queue.size
  end
end

