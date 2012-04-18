# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'open3'
require 'fcntl'

Open3.popen3('ruby test.rb') do |pin, pout, perr|
  write_map = { pout => $stdout, perr => $stderr, $stdin => pin }
  # [pin, pout, perr, $stdin, $stdout, $stderr].each do |io|
  #   io.fcntl(Fcntl::F_SETFL, Fcntl::O_NONBLOCK)
  # end
  # [pin, pout, perr, $stdin, $stdout, $stderr].each { |io| io.sync = false }
  loop do
    retval = select([pout, perr, $stdin], nil, [pin, $stdout, $stderr], nil)
    puts "select returned"
    for i in retval[0]
      exit(0) if i.eof
      str = i.read(512)
      write_map[i].write(str)
    end
    for i in retval[2]
      exit(1)
    end
  end
end

