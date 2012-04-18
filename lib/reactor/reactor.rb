# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
##
# The Reactor is a base class for all other reactors.  It is currently an
# abstract class, but this may change.
#
class Reactor

  class AlreadyRegistered < RuntimeError
  end

  class NotRegistered < RuntimeError
  end

  def initialize()
    raise NotImplementedError
  end

  ##
  # Register callback whenever data is ready to be read on io_object.
    # The implementation should throw AlreadyRegistered if there is already
    # a callback registered for this io_object.
    #
    # @param io_object the io object to register for.
    # @param callback a proc or method that gets called when data is ready.
    #
    def register_read(io_object, callback)
      raise NotImplementedError
    end

    ##
    # Register callback whenever data is ready to be written to io_object.
    # The implementation should throw AlreadyRegistered if there is already
    # a callback registered for this io_object.
    #
    # @param io_object the io object to register for.
    # @param callback a proc or method that gets called when the io_object is
    # ready to be written to.
    #
    def register_write(io_object, callback)
      raise NotImplementedError
    end

    ##
    # Register callback whenever an exceptional conditions occurs for io_object.
    # The implementation should throw AlreadyRegistered if there is already
    # a callback registered for this io_object.
    #
    # @param io_object the io object to register for.
    # @param callback a proc or method that gets called when the io_object has
    # an exceptional condition.
    #
    def register_error(io_object, callback)
      raise NotImplementedError
    end

    ##
    # Unregister a read handler for an io_object.  The implementation should
    # raise NotRegistered if there is no callback registered for this io_object.
    #
    # @param io_object the io object to unregister.
    #
    def unregister_read(io_object)
      raise NotImplementedError
    end

    ##
    # Unregister a write handler for an io_object.  The implementation should
    # raise NotRegistered if there is no callback registered for this io_object.
    #
    # @param io_object the io object to unregister.
    #
    def unregister_write(io_object)
      raise NotImplementedError
    end

    ##
    # Unregister an error handler for an io_object.  The implementation should
    # raise NotRegistered if there is no callback registered for this io_object.
    #
    # @param io_object the io object to unregister.
    #
    def unregister_error(io_object)
      raise NotImplementedError
    end

    ##
    # Run the reactor event loop until work is done or until the timeout is
    # reached.
    #
    # @param t the maximum amount of time to run the event loop.
    #
    def perform_work(t = nil)
      raise NotImplementedError
    end

    ##
    # Run the reactor event loop for t seconds (or indefinitely if t is nil).
    #
    # @param t the length of time to run the event loop.
    #
    def run_event_loop(t = nil)
      raise NotImplementedError
    end

    ##
    # End the reactor event loop.
    #
    def end_event_loop()
      raise NotImplementedError
    end

    ##
    # Determine if there the reactor has work to be done.
    #
    # @param t te length of time to wait until there is work to be done
    # (do not block by default; set this to nil to block).
    #
    # @return true if there is work pending, or false otherwise.
    #
    def work_pending(t = 0)
      raise NotImplementedError
    end

    ##
    # Schedule a timer event.
    #
    # @param callback a proc or method to be called whenever the timer goes off.
    # @param delta the amount of time to wait before the first timer goes off.
    # @param interval the amount of time to wait between intervals.
    #
    # @return the id of a timer event.
    #
    def schedule_timer(callback, delta, interval=0)
      raise NotImplementedError
    end

    ##
    # Unregister a timer event.
    #
    # @param timerid the id of the timer event to unregister.
    #
    def cancel_timer(timerid)
      raise NotImplementedError
    end

  end
