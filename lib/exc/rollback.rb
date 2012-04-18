# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'loaders'
requirelocal 'print_exception'

##
# A helper class for rolling back changes made when an exception occurs.
#
class Rollback
  attr_accessor :debug

  ##
  # Create a new Rollback object.  You should generally not have to do this
  # directly; use Rollback::rollback() instead.
  #
  def initialize(a=Array.new)
    @rb = a
    @debug = false
  end

  ##
  # Specify that the passed proc or method should be called when an exception
  # occurs.  All undo actions will be called in the reverse order in which
  # they were created.
  #
  def undo(x)
    @rb.push(x)
  end

  ##
  # Run the passed block, and call the given undo() actions in reverse order
  # if an exception occurs.  The exception will be properly propogated to the
  # caller.
  #
  # E.g.:
  # <pre>
  #   Rollback::rollback do |rb, *args|
  #     rb.undo(Proc.new { puts "1" })
  #     rb.undo(Proc.new { puts "2" })
  #     rb.undo(Proc.new { puts "3" })
  #     raise RuntimeError
  #   end
  # </pre>
  def self.rollback(*args, &block)
    a = Array.new
    rb = Rollback.new(a)
    begin
      yield rb, *args
    rescue Exception
      exc = $!
      a.reverse.each do |i|
        begin
          i.call
        rescue Exception
          # it's bad to get this exception in the first place; it's
          # even worse to let it propogate.
          print_exception $! if rb.debug
        end
      end
      raise exc, exc.message, exc.backtrace
    end
  end
end

