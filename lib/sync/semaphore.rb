# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'loaders'
require 'thread'
requirelocal 'wait_queue'

class Semaphore
  attr_reader :value

  def initialize(value)
    @value = value
    @mutex = Mutex.new
    @queue = WaitQueue.new
  end

  def lock
    @mutex.synchronize do
      if @value == 0 then
        @queue.wait(@mutex)
      end
      @value = @value - 1
    end
  end

  def try_lock
    @mutex.synchronize do
      if @value != 0 then
        @value = @value - 1
        return true
      else
        return false
      end
    end
  end

  def locked?
    return @value != 0
  end

  def unlock
    @mutex.synchronize do
      @value = @value + 1
      @queue.post
    end
  end

  def synchronize(*args)
    begin
      lock
      yield(*args)
    ensure
      unlock
    end
  end
end

