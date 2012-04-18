# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require '../extconf_helpers.rb'

IGNOREDIRS << 'rcr29'

EXTDIRS = []
Dir.foreach('.') do |file|
  if not ignoredir(file) then
    EXTDIRS << file
  end
end
MAKEDIRS = EXTDIRS

recurse_extdirs()
generate_makefile()

