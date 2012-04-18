# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers.rb'
require 'hacks/fix_trace_func'

$trace_enabled = false

$trace1 = Array.new
$trace1_id = set_trace_func proc { |*args|
  if $trace_enabled then
    $trace1.push(args)
  end
}

$trace2 = Array.new
$trace2_id = set_trace_func proc { |*args|
  if $trace_enabled then
    $trace2.push(args)
  end
}

$trace_enabled = true

class FixTraceFuncTest < RUNIT::TestCase

  def assert_traces_equal(trace1, trace2)
    assert_equal trace1.size, trace2.size
    trace1.each_index do |index|
      assert_equal trace1[index], trace2[index]
    end
  end

  def test_simple
    $trace_enabled = false
    remove_trace_func($trace1_id)
    remove_trace_func($trace2_id)
    $trace_enabled = true

    assert $trace1.size != 0
    assert $trace2.size != 0
    assert_equal $trace1.size, $trace2.size
    size = $trace1.size

    # Too slow to test the whole thing
    assert_traces_equal $trace1[0..100],     $trace2[0..100]
    assert_traces_equal $trace1[1000..1100], $trace2[1000..1100]
    assert_traces_equal $trace1[2000..2100], $trace2[2000..2100]
    assert_traces_equal $trace1[3000..3100], $trace2[3000..3100]
    assert_traces_equal $trace1[4000..4100], $trace2[4000..4100]
    assert_traces_equal $trace1[5000..5100], $trace2[5000..5100]
    assert_traces_equal $trace1[(size-100)..size], $trace2[(size-100)..size]
  end

end

exit run_test(FixTraceFuncTest)

