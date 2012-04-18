# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'loaders'
require 'thread'
requirelocal '../sync/null_mutex'
requirelocal 'reactor'
requirelocal 'timer_queue'

class SelectReactor < Reactor

  def initialize(mutex=nil)
    @mutex = mutex.nil? ? NullMutex.new : mutex

    @read_list = Array.new
    @write_list = Array.new
    @error_list = Array.new

    @read_handler = Hash.new
    @write_handler = Hash.new
    @error_handler = Hash.new

    @timer_queue = TimerQueue.new
    @end_event_loop = false
  end

  def register_read(io_object, callback)
    @mutex.synchronize() do
      raise AlreadyRegistered if not @read_handler[io_object].nil?
      @read_list.push(io_object)
      @read_handler[io_object] = callback
    end
  end

  def register_write(io_object, callback)
    @mutex.synchronize() do
      raise AlreadyRegistered if not @write_handler[io_object].nil?
      @write_list.push(io_object)
      @write_handler[io_object] = callback
    end
  end

  def register_error(io_object, callback)
    @mutex.synchronize() do
      raise AlreadyRegistered if not @error_handler[io_object].nil?
      @error_list.push(io_object)
      @error_handler[io_object] = callback
    end
  end

  def unregister_read(io_object)
    @mutex.synchronize() do
      raise NotRegistered if @read_handler[io_object].nil?
      @read_list.delete(io_object)
      @read_handler.delete(io_object)
    end
  end

  def unregister_write(io_object)
    @mutex.synchronize() do
      raise NotRegistered if @write_handler[io_object].nil?
      @write_list.delete(io_object)
      @write_handler.delete(io_object)
    end
  end

  def unregister_error(io_object)
    @mutex.synchronize() do
      raise NotRegistered if @error_handler[io_object].nil?
      @error_list.delete(io_object)
      @error_handler.delete(io_object)
    end
  end

  def run_event_loop(t = nil)
    ready = nil
    catch :end_reactor_event_loop do
      while t.nil? or t > 0 do
        start = Time.now
        max_wait_time = @timer_queue.max_wait_time()
        if not t.nil? and (max_wait_time.nil? or max_wait_time > t) then
          max_wait_time = t
        end
        @mutex.synchronize() do
          ready = select(
              @read_list,
              @write_list,
              @error_list,
              max_wait_time)
        end
        if ready then
          for s in ready[0]
            @read_handler[s].call(s)
          end
          for s in ready[1]
            @write_handler[s].call(s)
          end
          for s in ready[2]
            @error_handler[s].call(s)
          end
        end
        throw :end_reactor_event_loop if @end_event_loop
        t -= (Time.now - start) if not t.nil?
        @timer_queue.expire()
      end
      return
    end
  end

  def end_event_loop()
    throw :end_reactor_event_loop
    @end_event_loop = true
  end

  def work_pending(t = 0)
    return select(@read_list, @write_list, @error_list, t)
  end

  def schedule_timer(callback, delta, interval=0)
    return @timer_queue.add_timer(callback, delta, interval)
  end

  def cancel_timer(timerid)
    @timer_queue.remove_timer(timerid)
  end

end
