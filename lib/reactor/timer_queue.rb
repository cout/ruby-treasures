# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
class TimerQueue

public

class Timer
  attr_reader :timerid, :delta, :interval, :callback
  attr_accessor :next_timeout

  def initialize(timerid, delta, interval, callback)
    @timerid = timerid
    @delta = delta
    @interval = interval
    @callback = callback
    @next_timeout = Time.now + delta
  end
end

def initialize()
  @queue = Array.new
  @nextid = 0
  @mutex = Mutex.new
  @current_thread = nil
end

def add_timer(callback, delta, interval=0)
  synchronize do
    timerid = @nextid
    @nextid = @nextid.succ
    @queue.push(Timer.new(timerid, delta, interval, callback))
    return timerid
  end
end

def remove_timer(timerid)
  synchronize do
    @queue.delete_if { |x| x.timerid == timerid }
  end
end

def max_wait_time()
  synchronize do
    if @queue.size == 0 then
      return nil
    end
    
    current_time = Time.now

    next_timer = @queue[0]
    @queue.each do |timer|
      if timer.next_timeout < next_timer.next_timeout then
        next_timer = timer
      end
    end

    if next_timer.next_timeout > current_time then
      return next_timer.next_timeout - current_time
    else
      return 0
    end
  end
end

def expire()
  synchronize do
    current_time = Time.now
    @queue.each do |timer|
      if timer.interval == 0 && timer.next_timeout < current_time then
        @queue.delete(timer)
        timer.callback.call()
      else
        while timer.next_timeout < current_time
          timer.callback.call()
          timer.next_timeout += interval
        end
      end
    end
  end
end

private

def synchronize(*args)
  Thread.critical = true
  if @current_thread != nil && @current_thread != Thread.current then
    Thread.critical = false
    @mutex.lock
  end

  Thread.critical = true
  @current_thread = Thread.current
  Thread.critical = false

  yield(*args)

  Thread.critical = true
  @current_thread = nil
  Thread.critical = false

  @mutex.unlock
end

end

