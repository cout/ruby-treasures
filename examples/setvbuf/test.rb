# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'setvbuf'

$stdout.setvbuf(IO::NBF, nil)
$stdout.sync = false

loop do
  puts "This is a test."
  sleep 0.1
end

