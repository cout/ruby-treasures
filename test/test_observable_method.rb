# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers.rb'
require 'hacks/observable_method'

class Foo
  include Observable

  def run
    for i in 0..2 do
      changed()
      notify_observers(i)
    end
  end
end

class Bar
  attr_reader :log

  def initialize(f)
    f.add_observer(method_observer(:foo))
    @log = []
  end

  def foo(arg)
    @log.push(arg)
  end
end

class ObservableMethodTest < RUNIT::TestCase
  def test_simple
    f = Foo.new
    b = Bar.new(f)
    f.run

    assert_equal 0, b.log[0]
    assert_equal 1, b.log[1]
    assert_equal 2, b.log[2]
  end
end

exit run_test(ObservableMethodTest)

