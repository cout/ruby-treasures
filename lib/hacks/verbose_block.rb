# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
##
# Run a block, with $VERBOSE set to v.  No other threads will
# run while this block is being executed.
#
def verbose_block(v = true, &block)
  Thread.critical = true
  tmp = $VERBOSE
  $VERBOSE = v
  begin
    yield
  ensure
    $VERBOSE = tmp
    Thread.critical = false
  end
end

##
# Run a block, with $VERBOSE set to false.  No other threads will
# run while this block is being executed.
#
def terse_block(&block)
  verbose_block(false, &block)
end

