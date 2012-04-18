# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'socket'

server = TCPServer.new('localhost', 4242)
while socket = server.accept
    Thread.new(socket) do |socket|
        while !socket.eof
            str = socket.gets
            socket.puts str
        end
    end
end
