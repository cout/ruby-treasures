# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers'
require 'exc/exception_extensions'

class ExceptionExtensionsTest < RUNIT::TestCase
  def test_exception_data
    exc = nil
    begin
      raise "Foo!"
    rescue RuntimeError
      exc = $!
      exc.extend(ExceptionData)
      exc.data = 42
    end
    assert !exc.nil?
    assert_equal 42, exc.data
  end
end

exit run_test(ExceptionExtensionsTest)

