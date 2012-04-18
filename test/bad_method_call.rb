# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'rbconfig'

if Config::CONFIG['MAJOR'].to_i == 1 and Config::CONFIG['MINOR'].to_i < 7 then
  BadMethodCallError = NameError
else
  BadMethodCallError = NoMethodError
end

