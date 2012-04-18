# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'setvbuf_helper'

if false then

##
# A Ruby interface to setvbuf(3)
#
class IO
  ##
  # Call setvbuf(3) with the given mode and buffer (size is calculated
  # from the length of the buffer).
  #
  # @param mode one of IO::NBF (non-buffered), IO::FBF (fully-buffered),
  #             or IO::LBF (line-buffered).  IO::LBF is the default for
  #             $stdin/$stdout/$stderr when connected to a tty.  On most
  #             systens, IO::FBF is the default for
  #             $stdin/$stdout/$stderr when not connected to a tty, but
  #             this is system-dependant.  IO::FBF with a zero-length
  #             buffer is the default for all files.  The default for
  #             all other IO objects is unspecified.
  # @param buf  The buffer to give to setvbuf.  It may be a) a String
  #             object whose length is the length of the buffer, or b)
  #             nil, to indicate a zero-length buffer.
  def setvbuf(mode, buf)
  end
end

end
