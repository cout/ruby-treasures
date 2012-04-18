# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers'
require 'sync/semaphore'

class SemaphoreTest < RUNIT::TestCase

  # TODO: Assert something in this test
  def test_semaphore
    sem = Semaphore.new(2)
    mutex = Mutex.new
    threads = Array.new
    n = 0

    (1..5).each do |x|
      thread = Thread.new(x) do |x|
        # puts "Thread #{x} started"
        sem.synchronize do
          mutex.synchronize do
            n = n + 1
            # puts "#{x}: n = #{n}"
          end
          sleep 2
        end
        # puts "Thread #{x} exiting"
      end
      threads.push(thread)
    end

    threads.each do |thread|
      thread.join
    end
  end
end

exit run_test(SemaphoreTest)

