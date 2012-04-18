# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
# Note: 'loaders' uses this file, so please don't use requirelocal/loadlocal
# from here, because it probably won't work.

$initial_directory = Dir.getwd

##
# Return the full pathname of a file, relative to $initial_directory.
#
# TODO: The user must not chdir to an alternate directory before requiring this
# file.
#
# TODO: This does not check to see if the file does not exist.
#
# TODO: This does not check to see if the file is a shared object.
#
# TODO: This does not check to see if the file is "(eval)".
#
# @return the full pathname of $0, or nil if it cannot be determined.
# 
def caller_file_pathname(filename)
  File.expand_path(filename, $initial_directory)
end

##
# Parse a caller string and break it into its components.
#
# Note: If the user decides to redefine caller() to output data in a different
# format, then the results will be undefined.
#
# @return file (String), lineno (Integer), method (Symbol)
#
def parse_caller(caller_str)
  file, lineno, method = caller_str.split(':')
  if method =~ /in `(.*)'/ then
    method = $1.intern()
  end
  return file, lineno.to_i(), method
end

##
# Return a string representing the line at the given caller level.
#
# @param level the level of the line desired, relative to the the method that called caller_line.
#
# @return a string holding the contents of the desired line.
# 
def caller_line(level=0)
  dir = File.dirname(caller_file_pathname($0))
  file, lineno, method = parse_caller(caller[level.succ])
  File.open(File.expand_path(file, dir)) do |input|
    (lineno.to_i - 1).times { input.gets }
    return input.gets
  end
end

