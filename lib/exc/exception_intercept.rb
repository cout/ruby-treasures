# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
##
# Here's a neat way to intercept exceptions without rescuing them and
# rethrowing them (which doesn't work properly on Ruby 1.6).
#
# E.g.:
# <pre>
#   class MyException < Exception
#     def initialize
#       super "Foo!"
#     end
#   end
#   
#   exception_intercept(
#     proc {
#       raise MyException
#     },
#     proc { |exc|
#       case exc
#       when MyException
#         puts "Got the exception!"
#       else
#         puts "UH OH!"
#         kill_exception # don't let this exception propogate further
#       end
#     }
#   )
# </pre>

##
# Call main_block.  If an exception is thrown, then call rescue_block.
# The exception will propogate automatically unless kill_exception is
# called.
#
# Note that the rescue_block will be called when there is any type of
# exception.  Using "rescue Exception" does not catch exceptions that do
# not inherit from class Exception.
#
# The rescue_block will not be called when throw is used.  It will not
# be called when continuations are used.
#
def exception_intercept(main_block, rescue_block)
  exc = true
  begin
    begin
      main_block.call(exc)
      exc = false
    ensure
      rescue_block.call($!) if exc and not $!.nil?
    end
  rescue KillException
  end
end

def kill_exception
  raise KillException
end

class KillException < Exception
end

