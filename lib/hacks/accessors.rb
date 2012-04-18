# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
##
# A hack to add accessors for class variables
#
class Module
  ##
  # Works like attr_reader, but is for class methods.
  #
  def attr_class_reader(*symbols)
    symbols.each do |symbol|
      self.class_eval %[
        @@#{symbol} = nil unless defined? @@#{symbol}
        ##
        # @ignore
        def self.#{symbol}
          @@#{symbol}
        end
      ]
    end
  end

  ##
  # Works like attr_writer, but is for class methods.
  #
  def attr_class_writer(*symbols)
    symbols.each do |symbol|
      self.class_eval %[
        @@#{symbol} = nil unless defined? @@#{symbol}
        ##
        # @ignore
        def self.#{symbol}=(x)
          @@#{symbol} = x
        end
      ]
    end
  end
  
  ##
  # Works like attr_accessor, but is for class methods.
  #
  def attr_class_accessor(*symbols)
    attr_class_reader(*symbols)
    attr_class_writer(*symbols)
  end
end
