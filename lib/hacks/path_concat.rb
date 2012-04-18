# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
##
# Allow easy manipulation of paths using String./
#
# E.g.:
# <pre>
#   prefix = '/usr'/'local'
#     #=> "/usr/local"
#   prefix/'bin'
#     #=> "/usr/local/bin"
#   source_prefix/'linux-'+source_version/'.config'
#     #=> "/usr/src/linux-2.2.18/.config"
# </pre>
# 
class String
  def /(other)
    File.join(self, other)
  end
end

