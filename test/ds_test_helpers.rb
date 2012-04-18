# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
$:.unshift('../lib')
Dir.foreach('../ext') do |file|
  # TODO: This is definitely a hack
  if FileTest.directory?("../ext/#{file}") and file != '.' and file != '..' then
    $:.unshift("../ext/#{file}")
  end
end

srand(1)

require 'loaders'
require 'hacks/verbose_block'

# This is necessessary for old versions of runit
terse_block do
  require 'runit/testcase'
end

DEBUG = true

def random_string(n)
  str = ''
  n.times do
    str << ?A + rand(26)
  end
  return str
end

def run_block_safe(*args)
  begin
    yield(*args)
  rescue Exception
    puts $!
    puts $!.backtrace
  end
end

def format_container(a)
  case a
  when Array
    a.inspect
  else
    a.to_s
  end
end

def display_container(a)
  puts format_container(a)
end

def run_test(test, klass=nil)
  require 'runit/cui/testrunner'
  suite = test.suite
  testresult = RUNIT::CUI::TestRunner.run(suite)
  retval = (
      testresult.error_size   == 0 &&
      testresult.failure_size == 0)
  return retval ? 0 : 1
end

