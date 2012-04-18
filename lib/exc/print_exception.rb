# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
##
# Ruby does not provide a method to print exceptions exactly the same way it
# does, so here's a hack to return a string representing an exception plus
# backtrace, in printable form.
#
# @param exc the exception to print
# 
# @return a string representing the exception and its backtrace
#
def exception_str(exc=$!)
  str = ''
  first = true
  exc.backtrace.each do |bt|
    str << (first ? "#{bt}: #{exc.message} (#{exc.type})\n" : "\tfrom #{bt}\n")
    first = false
  end
  str
end

##
# Print an exception, the same way Ruby does it.
#
# @param exc the exception to print.
# @param out the IO object to print to.
#
def print_exception(exc=$!, out=$stdout)
  out.puts exception_str(exc)
end

