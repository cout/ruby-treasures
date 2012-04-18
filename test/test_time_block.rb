# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers'
require 'time_block'

class TimeBlockTest < RUNIT::TestCase
  def test_time_block
    time_block do |timer|
      assert_equal 0, timer.total_time.round
      sleep 1
      assert_equal 1, timer.total_time.round

      timer.stop
      assert_equal 1, timer.total_time.round
      sleep 2
      assert_equal 1, timer.total_time.round

      timer.start
      assert_equal 1, timer.total_time.round
      sleep 1
      assert_equal 2, timer.total_time.round
    end
  end
end

exit run_test(TimeBlockTest)

