# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'loaders'
require 'thread'
requirelocal 'select_reactor'

class ThreadedGtkReactor < SelectReactor

    def initialize()
        super()
        @select_thread = nil
    end

    def run_event_loop(t = nil)
        if t then
            timeout = Gtk::timeout_add(t) do
                Gtk::main_quit
            end
        end
        @select_thread = Thread.new do
            super.run_event_loop(t)
        end
        Gtk::main
        if t then
            Gtk::timeout_remove(timeout)
        end
        @select_thread.join
        @select_thread = nil
    end

    def end_event_loop()
        timer = schedule_timer(Proc.new {@select_thread.kill}, 0, 0)
        Thread.critical = true
        if @in_select then
            @select_thread.kill
            cancel_timer(timer)
        else
            @end_event_loop = true
        end
        Thread.critical = false
        Gtk::main_quit
    end

    def work_pending()
        return Gtk::events_pending() || super.work_pending()
    end

end
