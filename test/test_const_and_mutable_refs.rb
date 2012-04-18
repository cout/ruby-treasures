# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers'
require 'hacks/const_ref'
require 'hacks/mutable_ref'

class ConstAndMutableRefTest < RUNIT::TestCase
  def test_const_ref
    obj = "Foo!"
    ref = ConstRef.new(obj)

    assert_exception(TypeError) do
      ref.sub!('F', 'b')
    end

    obj.freeze
    assert_exception(TypeError) do
      ref.sub!('F', 'b')
    end
  end

  def test_const_ref_frozen
    obj = "Foo!"
    ref = ConstRef.new(obj)
    obj.freeze
    assert_exception(TypeError) do
      ref.sub!('F', 'b')
    end
  end

  def test_mutable_ref
    obj = "Foo!"
    ref = MutableRef.new(obj)
    ref.sub!('F', 'b')

    obj.freeze
    ref.sub!('b', 'F')
  end

  def test_mutable_ref_frozen
    obj = "Foo!"
    obj.freeze
    ref = MutableRef.new(obj)
    ref.sub!('b', 'F')
  end
end

exit run_test(ConstAndMutableRefTest)

