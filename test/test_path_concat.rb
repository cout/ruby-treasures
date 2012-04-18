# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers.rb'
require 'hacks/path_concat'

class PathConcatTest < RUNIT::TestCase
  def test_simple
    prefix = '/usr'/'local'
    assert_equal File.join('/usr', 'local'), prefix
    assert_equal File.join(prefix, 'bin'), prefix/'bin'
  end
end

exit run_test(PathConcatTest)

