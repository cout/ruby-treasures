# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers.rb'
require 'hacks/safe_method'
# require 'hacks/secret'
requirelocal 'bad_method_call'

class Foo
public
  def public_foo
    return :foo
  end

protected
  def protected_foo
    return :foo
  end

private
  def private_foo
    return :foo
  end

  # secret
  #   def secret_foo
  #     return :foo
  #   end
end

class SafeMethodTest < RUNIT::TestCase
  def test_simple
    f = Foo.new
    
    public_method = SafeMethod.new(f, :public_foo)
    assert_equal public_method.call(), :foo
    
    protected_method = SafeMethod.new(f, :protected_foo)
    assert_exception(BadMethodCallError) do
      protected_method.call()
    end
    
    private_method = SafeMethod.new(f, :private_foo)
    assert_exception(BadMethodCallError) do
      private_method.call()
    end
    
    # secret_method = SafeMethod.new(f, :secret_foo)
    # assert_exception(BadMethodCallError) do
    #   secret_method.call()
    # end
  end
end

exit run_test(SafeMethodTest)

