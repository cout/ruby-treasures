# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
# $Id: loaders.rb,v 1.11 2002/03/28 18:22:28 cout Exp $

##
# This should be the first file loaded by any user of this library.  If you
# don't load it first, then things may not work as expected.
#
if not defined?(LOADERS_RB) then
LOADERS_RB = true

begin
  require 'rbt/hacks/caller_helpers'
  require 'rbt/hacks/path_operations'
  require 'rbt/hacks/verbose_block'
rescue LoadError
  # need this for testing
  require 'hacks/caller_helpers'
  require 'hacks/path_operations'
  require 'hacks/verbose_block'
end

# TODO: If the user decides to chdir before requiring this file, then these
# functions will not work.

##
# Require a file from the same directory as the caller
#
def requirelocal(file)
  caller_file, caller_lineno, caller_method = parse_caller(caller[0])
  caller_dir = File.dirname(caller_file_pathname(caller_file))
  require File.join(caller_dir, file)
end

##
# Load a file from the same directory as the caller
#
def loadlocal(file)
  caller_file, caller_lineno, caller_method = parse_caller(caller[0])
  caller_dir = File.dirname(caller_file_pathname(caller_file))
  load File.join(caller_dir, file)
end

#TODO: I'm not sure a way around this problem yet.

terse_block do

$__old_require__ = method(:require)

$".each do |required_file|
  file = find_file_in_path(required_file)
  required_file.sub!(/^.*$/, file)
end

##
# A fixed version of require that uses the full pathname before checking to
# see if it has been required.
#
def require(file)
  file_to_require = find_file_in_path(file)
  $__old_require__.call(realpath(file_to_require))
end

$__old_load__ = method(:load)

##
# A fixed version of load that uses the full pathname before checking to
# see if it has been loadd.
#
def load(file)
  file_to_load = find_file_in_path(file)
  $__old_load__.call(file_to_load)
end

end # terse_block

end # if not defined?(LOADERS_RB)

