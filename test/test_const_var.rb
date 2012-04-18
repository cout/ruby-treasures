# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers.rb'
require 'hacks/const_var'

class ConstVarTest < RUNIT::TestCase

  def test_const_var
    f = "foo!"
    assert_equal "foo!", f
    assert_exception(RuntimeError) do
      const_var f do |g,|
        assert f.frozen?
        assert_equal f.id, g.id
        assert_exception(TypeError) { f.gsub!('f', 'b') }
        raise RuntimeError
      end
    end
    assert !f.frozen?
    f.gsub!('f', 'b')
    assert_equal "boo!", f

    f.freeze
    h = "hmm.."
    assert_equal "boo!", f
    const_var f, h do |g,|
      assert f.frozen?
      assert h.frozen?
      assert_equal f.id, g.id
      assert_exception(TypeError) { f.gsub!('b', 'f') }
    end
    assert f.frozen?
    assert_exception(TypeError) { f.gsub!('b', 'f') }
    assert_equal "boo!", f
  end

end

exit run_test(ConstVarTest)

