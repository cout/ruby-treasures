# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'extconf_helpers.rb'

PROJECT_NAME = 'RubyTreasures'

EXTDIRS = [ 'ext' ]
MAKEDIRS = EXTDIRS + [ 'test' ]

if ARGV[0] != '--norecurse' then
  recurse_extdirs()
end
generate_makefile()

makefile_append_str = <<END
docs:
  mkdir -p doc
  ruby -S makedoc.rb \
    --tmpl html2.tmpl \
    --srcdir lib \
    --docdir doc \
    --project #{PROJECT_NAME}

test:
  make test -C test

install: install2

install2:
  ruby doinstall.rb 42

.PHONY : test install install2
END

append_makefile {
  makefile_append_str.collect { |str|
    str.gsub(/^ +/, "\t").gsub(/ +/, ' ')
  }.join('')
}
 
