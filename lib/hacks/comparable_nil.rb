# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
##
# A hack so that nil can be compared to other objects
#
class NilClass
  def <=>(other)
    return other.nil? ? 0 : -1
  end
end

##
# Calling this method for a given class allows an instance of that class to
# be compared to nil using <=>.
#
def make_nil_comparable(klass=self)
  klass.class_eval %{
    if method_defined?(:<=>) then
      ##
      # @ignore
      alias_method :__make_nil_comparable_old_compare__, :<=>
    else
      ##
      # @ignore
      def __make_nil_comparable_old_compare__(other)
        raise(
          TypeError,
          "Unable to compare \#{self.inspect} to \#{other.inspect}")
      end
    end

    ##
    # @ignore
    def <=>(other)
      return 1 if other.nil?
      __make_nil_comparable_old_compare__(other)
    end
  }
end

