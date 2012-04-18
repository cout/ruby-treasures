# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'observer'

##
# A mixin that can be applied to Method and Proc objects (or any other
# object that responds to call()) to make them observable.  For example:
#
# <pre>
#   p = proc { puts 'foo!' }
#   p.extend(ObservableMethod)
# </pre>
#
module ObservableMethod
  def update(*args, &block)
    self.call(*args, &block)
  end
end

##
# Create an observable method.  Works just like Object#method, but
# returns a Method object that has been extended with ObservableMethod.
#
def method_observer(*args)
  m = method(*args)
  m.extend(ObservableMethod)
  return m
end


