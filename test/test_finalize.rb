# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers'
require 'hacks/finalize'

class Foo
  def initialize
    $initialized = true
  end

  def finalize
    $finalized = true
  end
end
enable_finalize(:Foo)

module Bar
  class Foo
    def initialize
      $initialized = true
    end

    def finalize
      $finalized = true
    end
  end
  enable_finalize(:Foo)
end

class FinalizeTest < RUNIT::TestCase
  def create_temporary(klass, *args, &block)
    klass.new(*args, &block)
    return nil
  end

  def reset
    $initialized = false
    $finalized = false
  end

  def test_simple
    reset()
    create_temporary(Foo)
    assert($initialized)
    GC.start
    assert($finalized)

    reset()
    create_temporary(Bar::Foo)
    assert($initialized)
    GC.start
    assert($finalized)
  end
end

exit run_test(FinalizeTest)

