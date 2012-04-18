# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers.rb'
require 'hacks/kernelless_object'

class KernellessObjectTest < RUNIT::TestCase
  def test_simple
    assert_equal nil, KernellessObject.included_modules.index(Kernel)
  end
end

exit run_test(KernellessObjectTest)

