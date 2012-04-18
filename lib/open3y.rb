# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'fcntl'

module Open3Y
  ##
  # A version of popen3 that yields (or returns) rd, wr, err, pid
  #
  def popen3_with_pid(*cmd)
    rd  = IO.pipe() # stdin  (child reads from 0, parent writes to 1)
    wr  = IO.pipe() # stdout (child writes to 1, parent reads from 0)
    err = IO.pipe() # stderr (child writes to 1, parent reads from 0)
    ps  = IO.pipe() # status (child writes to 1, parent reads from 0)

    # Set "close on exec".  As soon as the pipe is closed, we know that the
    # child process has made a successful call to exec (if we ever read data
    # from the pipe, though, it is an exception that was Marshaled from the
    # child).
    ps[1].fcntl(Fcntl::F_SETFD, Fcntl::FD_CLOEXEC)

    fork do
      # child
      rd[1].close  ; STDIN .reopen(rd[0])  ; rd[0].close
      wr[0].close  ; STDOUT.reopen(wr[1])  ; wr[1].close
      err[0].close ; STDERR.reopen(err[1]) ; err[1].close

      fork do
        # grandchild
        Marshal.dump(Process.pid, ps[1])
        ps[1].flush

        begin
          exec(*cmd)
          raise "exec returned!"
        rescue Exception
          Marshal.dump($!, ps[1])
          ps[1].flush
        end
        ps[1].close unless ps[1].closed?
        exit!
      end
    end

    # parent
    rd[0].close
    wr[1].close
    err[1].close
    ps[1].close

    pid = Marshal.load(ps[0])

    exc = nil
    begin
      exc = Marshal.load(ps[0])
    rescue EOFError
      # If we get an EOF error, then the exec was successful.
    end

    # If exc is set, then the exec was NOT successful.
    if not exc.nil? then
      raise exc
    end

    pi = [rd[1], wr[0], err[0], pid]
    if block_given? then
      begin
        return yield(*pi)
      ensure
        [rd[1], wr[0], err[0]].each do |p|
          p.close unless p.closed?
        end
      end
    end

    return pi
  end

  ##
  # The original popen3 that yields (or returns) rd, wr, err
  #
  def popen3(*cmd, &block)
    if block_given? then
      popen3_with_pid(*cmd) do |rd, wr, err, pid|
        yield rd, wr, err
      end
    else
      rd, wr, err, pid = popen3_with_pid(*cmd)
      return rd, wr, err
    end
  end

  module_function :popen3_with_pid
  module_function :popen3
end

if $0 == __FILE__
  a = Open3X.popen3("nroff -man")
  Thread.start do
    while line = gets
      a[0].print line
    end
    a[0].close
  end
  while line = a[1].gets
    print ":", line
  end
end

