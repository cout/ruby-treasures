# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
module Lock
  ##
  # Get two locks at once; in order to prevent deadlock, don't keep
  # one lock if both cannot be obtained.
  #
  # TODO: Can I make this generic for n locks?
  #
  def self.double_lock(lock1, lock2)
    lock1.try_lock
    loop do
      break if lock2.try_lock
      lock1.unlock
      lock2.lock

      break if lock1.try_lock
      lock2.unlock
      lock1.lock
    end
  end

  ##
  # Unlock two locks at once.
  #
  def self.double_unlock(lock1, lock2)
    lock1.unlock
    lock2.unlock
  end

  ##
  # Lock one lock and unlock another.
  #
  def self.swap_lock(locked_lock, unlocked_lock)
    @unlocked_lock.lock
    @locked_lock.unlock
  end

  ##
  # Call a block with Thread.critical set to true; ensure that it is
  # reset to false after.
  def self.atomic(&block)
    Thread.critical = true
    begin
      block.call
    ensure
      Thread.critical = false
    end
  end
end

