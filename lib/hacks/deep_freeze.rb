# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'loaders'
requirelocal 'each_instance_variable'
requirelocal 'const_method'
requirelocal '../exc/print_exception'
requirelocal '../sync/lock'

class Object
public
  ##
  # Freeze an object and all it's instance variables.  Will not recurse
  # past max_depth (specify a negative number to recurse indefinitely).
  #
  # To deep-freeze containers (such as Array), specify follow_each=true.
  #
  # Note that a class may define its own deep_freeze method if this one
  # is not suitable.
  #
  # TODO: Does not deep freeze certain data types, such as Binding
  #
  # TODO: Does not properly deep freeze classes (will omit class
  # variables)
  #
  def deep_freeze(max_depth=-1, follow_each=false)
    seen_objs = Hash.new
    unfreeze_objs = Array.new
    begin
      deep_freeze_helper(max_depth, follow_each, seen_objs, unfreeze_objs)
    rescue Exception => exc
      # This is a hack to "unfreeze" a list of objects.  Unfreezing is
      # not supposed to be an easy operation.  It relies on callcc being
      # able to "bypass" an ensure block.
      begin
        Lock.atomic do
          Object.class_eval do
            define_method(:deep_freeze_rollback_helper) { |cc| cc.call() }
          end
          unfreeze_objs.each do |obj|
            begin
              callcc do |cc|
                mutable_send(obj, :deep_freeze_rollback_helper, cc)
              end
            rescue Exception
              print_exception $!
            end
          end
          Object.class_eval { remove_method :deep_freeze_rollback_helper }
        end
      rescue Exception
        print_exception $!
      end
      raise exc, exc.message, exc.backtrace
    end
  end

protected
  def deep_freeze_helper(max_depth, follow_each, seen_objs, unfreeze_objs)
    return if max_depth == 0
    return if seen_objs[self.__id__]
    seen_objs[self.__id__] = true

    if not self.frozen? then
      self.freeze
      unfreeze_objs.push(self)
    end

    # iterate over all instance variables
    each_instance_variable do |name, obj|
      obj.deep_freeze_helper(
          max_depth - 1,
          follow_each,
          seen_objs,
          unfreeze_objs)
    end

    # iterate over each sub-object in the container
    if follow_each then
      if self.respond_to?(:each) and not self.kind_of?(String) then
        self.each do |*objs|
          objs.each do |obj|
            obj.deep_freeze_helper(
                max_depth - 1,
                follow_each,
                seen_objs,
                unfreeze_objs)
          end
        end
      end
    end
  end
end

