# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'delegate'
require 'weakref'

module Refcountable
public
  def add_ref
    @ref_count += 1
    puts @ref_count
  end

  def remove_ref
    @ref_count -= 1
    if @ref_count <= 0 then
      @obj.finalize if @obj.respond_to?(:finalize)
      @obj = nil
      GC.start # TODO: why does @obj not get finalized here?
    end
  end

  def refer(*args, &block)
    add_ref()
    begin
      return block.call(*args)
    ensure
      remove_ref()
    end
  end

  attr_reader :ref_count

private
  def init_ref(obj)
    @ref_count = 0
  end
end

class Refcount
  include Refcountable
  def initialize(obj)
    init_ref(obj)
  end
end

def Refcounted_Class(klass)
  # DelegateClass doesn't properly delegate to WeakRef.
  customer = Class.new(SimpleDelegator)
  customer.class_eval %{
    include Refcountable
    @@klass = klass
    def initialize(*args)
      impl = @@klass.new(*args)
      super(WeakRef.new(impl))
      init_ref(impl)
    end
  }
  return customer
end

