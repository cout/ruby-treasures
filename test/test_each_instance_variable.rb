# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers'
require 'hacks/each_instance_variable'

class Foo
  def initialize
    @x = 1
    @y = 42
  end
end

class EachInstanceVariableTest < RUNIT::TestCase
  def test_simple
    expected_result =  [ [:@x, 1], [:@y, 42] ]
    got_expected_result = [ false, false ]

    f = Foo.new
    f.instance_eval { 
      each_instance_variable do |*x|
        expected_result.each_index do |i|
          if x == expected_result[i] then
            got_expected_result[i] = true
          end
        end
      end
    }

    got_expected_result.each do |result|
      assert result
    end
  end
end

exit run_test(EachInstanceVariableTest)

