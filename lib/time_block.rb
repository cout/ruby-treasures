# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
class Timer
  attr_reader :start_time
  attr_reader :end_time

  def initialize
    @start_time = nil
    @end_time = nil
    @total_time = 0
    @runnning = nil
    start
  end

  def start
    @start_time = Time.now
    @running = true
  end

  def stop
    @end_time = Time.now
    @total_time += @end_time - @start_time
    @running = false
  end

  def running?
    return @running
  end

  def stopped?
    return !@running
  end

  def total_time
    if running? then
      return @total_time + (Time.now - @start_time)
    else
      return @total_time
    end
  end
end

def time_block
  timer = Timer.new
  yield timer
  return timer.total_time
end

