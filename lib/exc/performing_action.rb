# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
##
# Appends extra information to an exception about what was being done at
# the time the exception was raised.
#
# Example:
# <code>
#
# performing_action('playing with Ruby') do
#   performing_action('doing some silly things') do
#     raise RuntimeError
#   end
# end
#
# #=> test.rb:3 RuntimeError: RuntimeError
#             while doing some silly things
#             while playing with Ruby
#             from test.rb:2:in `performing_action'
#             from test.rb:2
#             from test.rb:1: in `performing_action'
#             from test.rb:1
# </code>
#
def performing_action(action)
  begin
    yield
  ensure
    if $! then
      if not ExceptionActions === $! then
        $!.extend(ExceptionActions)
      end
      $!.actions.push(action)
    end
  end
end

##
# A mixin used by performing_action()
#
module ExceptionActions
  attr_reader :actions

  def self.extend_object(obj) 
    super(obj)
    obj.instance_eval { @actions = [] }
  end

  def to_s
    return super + @actions.map { |a| "\n\twhile #{a}" }.join
  end

  alias_method :message, :to_s
  alias_method :to_str, :to_s
end

performing_action('playing with Ruby') do
  performing_action('doing some silly things') do
    raise RuntimeError
  end
end
