# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
# Grab BLOCKTAG and BLOCK from eval.c and put it into ./block.h
# Grab blk_mark and blk_free from eval.c and put it into ./block.i
#
# Usage: ruby block.rb /path/to/ruby-1.6.5/eval.c
#

File.open(ARGV[0], "r") do |input|
  writing = writing_next = false
  File.open("block.h", "w") do |output|
    output.puts "#ifndef RUBY_BLOCK_H"
    output.puts "#define RUBY_BLOCK_H"
    output.puts "#include <ruby.h>"
    output.puts "#include <node.h>"
    input.each_line do |line|
      case line
      when /^(struct BLOCKTAG|struct BLOCK)/
        writing = writing_next = true
      when /^};/
        writing_next = false
      when /^\#define\s+(BLOCK_DYNAMIC|DVAR_DONT_RECYCLE)/
        writing = true
        writing_next = false
      end
      if writing then
        output.puts line
      end
      writing = writing_next
    end
    output.puts "#endif"
  end
end

File.open(ARGV[0], "r") do |input|
  writing = writing_next = false
  maybe_write = nil
  File.open("block.i", "w") do |output|
    output.puts '#include "block.h"'
    input.each_line do |line|
      case line
      when /^static void/
        maybe_write = line
      when /^(blk_mark|blk_free|frame_dup|scope_dup)/
        output.puts maybe_write
        writing = writing_next = true
      when /^}/
        writing_next = false
      end
      if writing then
        output.puts line
      end
      writing = writing_next
    end
  end
end
