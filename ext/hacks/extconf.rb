# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'mkmf'
require 'ftools'
require '../../extconf_helpers.rb'

PROJECTS = [
  'call_stack',
  'const_helpers',
  'kernelless_object',
  'safe_send',
  'each_instance_variable',
  'super_method'
]

MAKEFILES = []
PROJECTS.each do |project|
  $objs = [ "#{project}.o" ]
  $CFLAGS = '-g -Wall'
  create_makefile(project)
  new_makefile = "Makefile.#{project}"
  File::mv 'Makefile', new_makefile
  MAKEFILES << new_makefile
end

generate_makefile()

# Get struct METHOD from eval.c (if available)
filename = File.join(CONFIG['srcdir'], 'eval.c')
if File.exists?(filename) then
  output = false
  File.open(filename, 'r') do |infile|
    File.open('struct_method.h', 'w') do |outfile|
      infile.each_line do |line|
        case line
        when /^struct METHOD \{/
          output = true
        when /^bm_mark\(.*\)/
          outfile.puts("static void")
          output = true
        when /}/
          outfile.puts(line) if output
          output = false
        end
        outfile.puts(line) if output
      end
    end
  end
else
  puts "Warning: #{filename} not found; using default"
  File.open('struct_method.h', 'w') do |outfile|
    outfile.puts '#include "default_struct_method.h"'
  end
end

