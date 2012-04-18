# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'gtk'
require 'lglade'
require 'socket'
require 'rbt/reactor/threaded_gtkreactor'

class Test
    WHITE = Gdk::Color.new(255, 255, 255)
    BLACK = Gdk::Color.new(0, 0, 0)

    def initialize(reactor)
        @glade = GladeXML.new("test.glade") {|handler| method(handler)}
        @text = @glade.getWidget("text1")
        @font = Gdk::Font::fontset_load("*fixed*,*")
        @text.set_editable(true)
        @socket = TCPSocket.new('localhost', 4242)
        @reactor = reactor
        @reactor.register_read(@socket, method("handle_read"))
        @mutex = Mutex.new
    end

    def on_test_btn_clicked
        @mutex.synchronize do
            puts "test button clicked"
            @socket.puts("foo")
        end
    end

    def on_exit_btn_clicked
        @mutex.synchronize do
            @reactor.end_event_loop
        end
    end

    def on_window_destroy
        @mutex.synchronize do
            @reactor.end_event_loop
        end
    end

    def handle_read(io_object)
        @mutex.synchronize do
            text = io_object.gets()
            puts "inserting #{text} into @text"
            @text.insert(@font, BLACK, WHITE, text)
        end
    end
end

reactor = ThreadedGtkReactor.new
test = Test.new(reactor)
reactor.run_event_loop
