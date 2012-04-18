# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'loaders'
require 'delegate'
require 'thread'
requirelocal 'call_stack'

##
# Create a Proc that is dumpable.  If you load the DumpableProc in the same
# Ruby interpreter as it was created, then the proc will be created with the
# same binding (and bound?() will return true).  Since a binding cannot be
# sent across the wire, however, Proc's that are marshalled across and then
# sent to another interpreter will get a different binding (and are said to
# be unbound).
#
# Example:
# <pre>
#   y = 42
#   dp = DumpableProc.new %{ |x|
#     p x, y
#   }
#   dp.call(1)                          #=> 1
#                                       #=> 42
#   dump_str = Marshal.dump(dp)
#   puts dump_str                       #=> u:DumpableProc0:538120024: |x|
#                                       #=>   p x, y
#   dp2 = Marshal.load(dump_str)
#   dp2.call(2)                         #=> 2
#                                       #=> 42
#   DumpableProc.release(dp.id)
# </pre>
#
class DumpableProc < DelegateClass(Proc)
  ##
  # Return the id of a DumpableProc.  When you are done with a DumpableProc,
  # and you will not need to _load it again, pass this value to release().
  # Releasing an id will free memory associated with the DumpableProc; if
  # the DumpableProc is _load'ed again after it has been released, then
  # it will be re-created with a new binding.
  #
  attr_reader :id

  @@id = 0
  @@bindings = Hash.new

  ##
  # Create a new DumpableProc.
  #
  # @param str a string representing the proc
  # @param the_binding the binding to create the proc in (default is to create
  # the proc in the caller's binding)
  # @param id an id to be associated with the proc; should be left nil
  #
  def initialize(str, the_binding=nil, id=nil)
    the_binding = caller_binding() if !the_binding
    @bound = (the_binding != false)
    @proc = eval "proc { #{str} }", the_binding
    @str = str
    Thread.critical = true
    begin
      if id.nil? then
        @id = @@id
        @@id = @@id.succ
      else
        @id = id
      end
      @@bindings[@id] = the_binding
    ensure
      Thread.critical = false
    end
    super(@proc)
  end

  ##
  # Determine if a DumpableProc is bound to its original binding, or whether
  # it has been given a new binding.
  #
  # @return true if the proc has its original binding, false otherwise.
  #
  def bound?()
    @bound
  end

  ##
  # Return the (non-dumpable) Proc object associated with this DumpableProc.
  # This is necessary for functions that expect to receive a real proc object
  # and not a delegate object.
  #
  def to_proc()
    @proc
  end

  ##
  # Dump a DumpableProc to a string.
  #
  def _dump(x)
    Thread.critical = true
    begin
      return "#{@id}:#{self.type.id}:#{@str}"
    ensure
      Thread.critical = false
    end
  end

  ##
  # Load a DumpableProc from a string.
  # 
  def self._load(str)
    Thread.critical = true
    begin
      id_str, class_id_str, str = str.split(":", 3)
      if self.id != class_id_str.to_i or @@bindings[id_str.to_i] == nil then
        # Can't pass a binding across the wire
        return self.new(str, false)
      else
        return self.new(str, @@bindings[id_str.to_i], id_str.to_i)
      end
    ensure
      Thread.critical = false
    end
  end

  ##
  # Release a binding associated with a DumpableProc.  If you do not call this
  # method, then you will leak memory.
  #
  def self.release(id)
    @@bindings.delete(id)
  end
end


