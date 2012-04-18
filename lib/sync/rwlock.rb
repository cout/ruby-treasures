# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'loaders'
require 'thread'
requirelocal 'semaphore'
requirelocal 'lock'

##
# A read/write lock.
#
# TODO: I'm not yet sure how to implement this correctly, or how to test it.
#
class RWLock
  attr_reader :reader_count, :writer_count

  def initialize(readers = -1)
    @readers = readers

    @write_lock = Mutex.new
    @read_lock = Mutex.new
    @read_sem = Semaphore.new(@readers)

    @reader_count = 0
    @writer_count = 0
  end

  def lock_read
    @read_sem.lock
    @write_lock.synchronize do
      if @reader_count == 0 then
        @read_lock.lock
      end
      @reader_count += 1
    end
  end

  def lock_write
    Lock.double_lock(@read_lock, @write_lock)
    @writer_count += 1
  end

  def unlock_read
    @write_lock.synchronize do
      @reader_count -= 1
      if @reader_count == 0 then
        @read_lock.unlock
      end
    end
    @read_sem.unlock
  end

  def unlock_write
    @writer_count -= 1
    Lock.double_unlock(@read_lock, @write_lock)
  end

  def synchronize_read(*args)
    begin
      lock_read
      yield(*args)
    ensure
      unlock_read
    end
  end

  def synchronize_write(*args)
    begin
      lock_write
      yield(*args)
    ensure
      unlock_write
    end
  end

end

##
# A wrapper around a read/write lock that has the same interface as a
# Mutex and performs only read locks
#
# Example:
# <pre>
#   rwlock = RWLock.new
#   read_lock = ReadLock.new(rwlock)
#   read_lock.synchronize do
#     # ...
#   end
# </pre>
class ReadLock
  def initialize(obj)
    @obj = obj
  end

  def lock
    @obj.lock_write
  end

  def try_lock
    @obj.try_write
  end

  def unlock
    @obj.unlock_write
  end

  def synchronize(&block)
    @obj.synchronize_write(&block)
  end
end

##
# A wrapper around a read/write lock that has the same interface as a
# Mutex and performs only write locks
class WriteLock
  def initialize(obj)
    @obj = obj
  end

  def lock
    @obj.lock_write
  end

  def try_lock
    @obj.try_write
  end

  def unlock
    @obj.unlock_write
  end

  def synchronize(&block)
    @obj.synchronize_write(&block)
  end
end

