# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'mkmf'

create_makefile('rcr29')

File.open('Makefile', 'a') do |makefile|
makefile << <<-END
CFLAGS := $(CFLAGS) -g -Wall -DRUBY_TREASURES
END
end

