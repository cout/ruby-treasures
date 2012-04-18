# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers.rb'
require 'hacks/dumpable_proc'

class DumpableProcTest < RUNIT::TestCase
  def test_simple
    y = 42
    dp = DumpableProc.new %{ |x|
      [x, y]
    }
    assert_equal [1, 42], dp.call(1)

    dump_str = Marshal.dump(dp)
    assert dump_str =~ /DumpableProc/

    dp2 = Marshal.load(dump_str)
    assert_equal [2, 42], dp.call(2)

    DumpableProc.release(dump_str)

    # TODO: Test forking and loading the proc elsewhere
  end
end

exit run_test(DumpableProcTest)

