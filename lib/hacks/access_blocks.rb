# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'loaders'
requirelocal 'secret'

##
# A hack to allow specifying public/private/protected using a block.  Based on
# an idea proposed by David Alan Black.
#
# E.g.:
# <pre>
# class Thing
#   private do
#     def hidden
#       puts 'hi'
#     end
#   end
#
#   def visible
#     hidden
#   end
# end
# </pre>
class Module
  PUBLIC    = 0
  PROTECTED = 1
  PRIVATE   = 2
  SECRET    = 3

  [ 'public', 'protected', 'private', 'secret'].each do |access_level|
    ##
    # @ignore
    eval "alias_method :__old_access_blocks_#{access_level}__, :#{access_level}"
  end

  def private(*args, &block)
    __old_access_blocks_private__(args)
    block.call
    __old_access_blocks_private__(args)
  end
end
