# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers'
require 'exc/rollback'

class RollbackTest < RUNIT::TestCase
  def test_no_exception
    x = []
    Rollback::rollback do |rb, *args|
      rb.undo(Proc.new { x.push(1) })
      rb.undo(Proc.new { x.push(2) })
      rb.undo(Proc.new { x.push(3) })
    end
    assert_equal 0, x.size
  end

  def test_exception
    x = []
    assert_exception(RuntimeError) do
      Rollback::rollback do |rb, *args|
        rb.undo(Proc.new { x.push(1) })
        rb.undo(Proc.new { x.push(2) })
        rb.undo(Proc.new { x.push(3) })
        raise RuntimeError
      end
    end
    assert_equal 3, x.size
    assert_equal 3, x[0]
    assert_equal 2, x[1]
    assert_equal 1, x[2]
  end
end

exit run_test(RollbackTest)

