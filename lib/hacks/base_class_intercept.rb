# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
class Module
  ##
  # Based on an anonymous posting on Rubygarden.  Use this when a method in
  # the base class returns an instance of the base class instead of an instance
  # of the derived class.
  #
  def base_class_intercept(*methods)
    methods.each {|m|
      self.module_eval <<-END
        ##
        # @ignore
        def #{m}(*args, &block)
          retval = super(*args, &block)
          retval.type==#{self} ? retval : #{self}.new(retval) #return
        end
      END
    }
  end
end

