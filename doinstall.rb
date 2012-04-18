# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
if ARGV[0] != '42' then
  raise 'Do not run this program directly; use "make install" instead.'
end

require 'find'
require 'ftools'
require 'rbconfig'

SRCDIR = 'lib'
SITELIBDIR = File.join(Config::CONFIG['sitelibdir'])
LIBDIR = File.join(SITELIBDIR, 'rbt')
File.makedirs(LIBDIR)

puts "Installing to #{LIBDIR}"
Dir.chdir(SRCDIR)
Find.find('.') do |file|
  if file =~ /\.rb$/ then
    dir = File.join(LIBDIR, File.dirname(file))
    File.makedirs(dir)
    File.install(file, dir, 0644, true)
  end
end

# Install loaders.rb separately
File.install('hacks/loaders.rb', SITELIBDIR, 0644, true)

