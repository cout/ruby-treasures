# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
class Module
  ##
  # A clean way to override methods without resorting to alias_method.  The
  # original method can be called with super().
  #
  # This works by giving the current class two anonymous base classes: one
  # containing the original method, and one containing the new method.  Thus,
  # the original method must NOT make a call to super().
  #
  # @param symbols a list of symbols to override
  # @param block a block which defines the new methods.
  #
  # <pre>
  #   class Foo
  #     def foo
  #       puts "foo!"
  #     end
  #
  #     override_method :foo do
  #       def foo
  #         puts "foo 2!"
  #         super()
  #       end
  #     end
  #
  #     override_method :foo do
  #       def foo
  #         puts "foo 3!"
  #         super()
  #       end
  #     end
  #   end
  #
  #   Foo.new.foo #=> foo 3!
  #               #=> foo 2!
  #               #=> foo 1!
  # </pre>
  #
  def override_method(*symbols, &block)
    # We want something like this:
    #   current < module with new methods < module with old methods < ancestors
    new_methods = Module.new
    old_methods = Module.new
    include new_methods

    symbols.each do |symbol|
      old_methods.__send__(:define_method, symbol, instance_method(symbol))
      new_methods.__send__(:include, old_methods)
      new_methods.module_eval(&block)
      define_method(symbol, new_methods.instance_method(symbol))
    end
  end
end

