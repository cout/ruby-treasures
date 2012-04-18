# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers'
require 'sync/rwlock'

class RWLockTest < RUNIT::TestCase

  def check(rwlock)
    readers = rwlock.reader_count
    writers = rwlock.writer_count

    # Make sure we have readers or writers, not both
    assert !(writers > 0 && readers > 0)

    # Make sure we don't have more than one writer
    assert writers <= 1

    if readers > @max_readers then
      @max_readers = readers
    end
  end

  def test_rwlock
    @max_readers = 0

    rwlock = RWLock.new(5)
    threads = Array.new
    n = 0

    (1..10).each do |x|
      thread = Thread.new(x) do |x|
        # puts "Thread #{x} started"
        3.times do
          check(rwlock)
          rwlock.synchronize_write do
            check(rwlock)
            n = n + 1
            check(rwlock)
            # puts "#{x}: writer, n = #{n}"
            check(rwlock)
            sleep 1
            check(rwlock)
          end
          check(rwlock)
          # puts "#{x}: done with writing, ready to read"
          check(rwlock)
          rwlock.synchronize_read do
            check(rwlock)
            # puts "#{x}: reader, n = #{n}"
            check(rwlock)
            sleep 1
            check(rwlock)
          end
          check(rwlock)
          check(rwlock)
        end
        # puts "Thread #{x} exiting"
      end
      threads.push(thread)
    end

    threads.each do |thread|
      thread.join
    end

    assert_equal @max_readers, 5
    # puts "Max readers: #{@max_readers}"
    # puts "(should be no greater than 5)"
  end
end

exit run_test(RWLockTest)

