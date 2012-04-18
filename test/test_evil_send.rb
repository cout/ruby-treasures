# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers'
require 'hacks/safe_send'
requirelocal 'bad_method_call'

class Foo
public
  def public_foo(&block)
    private_foo(&block)
  end
  
protected
  def protected_foo(&block)
    private_foo(&block)
  end
  
private
  def private_foo
    if block_given? then
      return yield
    else
      return 42
    end
  end
end

class SendTest < RUNIT::TestCase
  def test_safe_send
    f = Foo.new
    assert_equal 42, safe_send(f, :public_foo)
    assert_exception(BadMethodCallError) { safe_send(f, :protected_foo) }
    assert_exception(BadMethodCallError) { safe_send(f, :private_foo) }
    assert_equal 0, safe_send(f, :public_foo) { 0 }
    assert_exception(BadMethodCallError) { safe_send(f, :protected_foo) { 0 } }
    assert_exception(BadMethodCallError) { safe_send(f, :private_foo) { 0 } }
  end

  def test_evil_send
    f = Foo.new
    assert_equal 42, evil_send(f, :public_foo)
    assert_equal 42, evil_send(f, :protected_foo)
    assert_equal 42, evil_send(f, :private_foo)
    assert_equal 0, evil_send(f, :public_foo) { 0 }
    assert_equal 0, evil_send(f, :protected_foo) { 0 }
    assert_equal 0, evil_send(f, :private_foo) { 0 }
  end
end

exit run_test(SendTest)

