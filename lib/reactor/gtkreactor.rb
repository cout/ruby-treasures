# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'loaders'
require 'gtk'
require 'thread'
requirelocal 'reactor'

class GtkReactor < Reactor

    GDK_INPUT_READ       = 1 << 0
    GDK_INPUT_WRITE      = 1 << 1
    GDK_INPUT_EXCEPTION  = 1 << 2

    class AlreadyRegistered < RuntimeError
    end

    class NotRegistered < RuntimeError
    end

    def initialize()
        @mutex = Mutex.new
        
        @read_handler = Hash.new
        @write_handler = Hash.new
        @error_handler = Hash.new

        @select_thread = nil

        @next_timerid = 0
        @timerid_to_gtkid = Hash.new
    end

    def register_read(io_object, callback)
        @mutex.synchronize() do
            if @read_handler[io_object] then
                raise AlreadyRegistered
            end
            @read_handler[io_object] = Gtk::input_add(
                    io_object, GDK_INPUT_READ) do
                callback.call(io_object)
            end
        end
    end

    def register_write(io_object, callback)
        @mutex.synchronize() do
            if @write_handler[io_object] then
                raise AlreadyRegistered
            end
            @write_handler[io_object] = Gtk::input_add(
                    io_object, GDK_INPUT_WRITE) do
                callback.call(io_object)
            end
        end
    end

    def register_error(io_object, callback)
        @mutex.synchronize() do
            if @error_handler[io_object] then
                raise AlreadyRegistered
            end
            @error_handler[io_object] = Gtk::input_add(
                    io_object, GDK_INPUT_EXCEPTION) do
                callback.call(io_object)
            end
        end
    end

    def unregister_read(io_object)
        @mutex.synchronize() do
            if @read_handler[io_object] == nil then
                raise NotRegistered
            end
            Gtk::input_remove(@read_handler[io_object])
            @read_handler.delete(io_object)
        end
    end

    def unregister_write(io_object)
        @mutex.synchronize() do
            if @write_handler[io_object] == nil then
                raise NotRegistered
            end
            Gtk::input_remove(@write_handler[io_object])
            @write_handler.delete(io_object)
        end
    end

    def unregister_error(io_object)
        @mutex.synchronize() do
            if @error_handler[io_object] == nil then
                raise NotRegistered
            end
            Gtk::input_remove(@error_handler[io_object])
            @error_handler.delete(io_object)
        end
    end

    def run_event_loop(t = nil)
        if t then
            timeout = Gtk::timeout_add(t) do
                Gtk::main_quit
            end
        end
        Gtk::main
        if t then
            Gtk::timeout_remove(timeout)
        end
    end

    def end_event_loop()
        Gtk::main_quit
    end

    def work_pending()
        return Gtk::events_pending
    end
    
    def schedule_timer(callback, delta, interval=0)
        timerid = @next_timerid
        @next_timerid = @next_timerid.succ
        gtkid = Gtk::timeout_add(delta) do
            Gtk::timeout_remove(@timerid_to_gtkid(callback))
            if interval != 0 then
                gtkid = Gtk::timeout_add(interval) do
                    callback.call
                end
                @timerid_to_gtkid() = gtkid
            end
            callback.call
        end
        @timerid_to_gtkid(timerid) = gtkid
        return timerid
    end
    
    def cancel_timer(timerid)
        Gtk::timeout_remove(@timerid_to_gtkid(timerid))
        @timerid_to_gtkid.delete(timerid)
    end

end
