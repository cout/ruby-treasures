# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
# Ruby Treasures 0.2
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
# Run this Ruby script to prepare the RubyTreasures distribution for
# publication.

require 'find'
require 'ftools'

# Create a ChangeLog
changelog_created = false
[
  '/usr/share/cvs/contrib',
  '/usr/lib/cvs/contrib',
  '/usr/local/share/cvs/contrib',
  '/usr/local/lib/cvs/contrib'
].each do |dir|
  file = File.join(dir, 'rcs2log')
  if File.exist?(file) then
    system(
      "#{file} -R -i 4 -u " +
      "'cout\tPaul Brannan\tcout@rm-f.net' > ChangeLog")
    changelog_created = true
    break
  end
end
if not changelog_created then
  puts "WARNING: Could not find rcs2log; not generating ChangeLog"
end

# Remove CVSROOT from the ChangeLog
cvsroot = File.readlines('CVS/Root')[0]
if cvsroot =~ /:.*?:.*?:(.*)/ then
  cvsdir = File.join($1, 'ds/')
  File.rename('ChangeLog', 'ChangeLog.orig')
  File.open('ChangeLog.orig', 'r') do |changelog_in|
    File.open('ChangeLog', 'w') do |changelog_out|
      changelog_in.each_line do |line|
        line.gsub!(/#{cvsdir}/, '')
        changelog_out.puts line
      end
    end
  end
  File.delete('ChangeLog.orig')
else
  puts "WARNING: Could not parse CVSROOT; not beautifying ChangeLog"
end

# Create documentation
# This requires a Makefile to exist, but we don't want the Makefiles in the
# final tarball.
system("ruby extconf.rb --norecurse")
system("make docs")
puts "Removing Makefile"
File.rm_f('Makefile')

# Add licences to the top of every file and remove unnecessary files

license = IO.readlines('LICENSE')
ruby_license_comment = license.map { |i| i.sub(/^/, '# ') }
c_license_comment = ["/*\n"] + license.map { |i| i.sub(/^/, ' * ') } + [" */\n"]

def rm_rf(dir)
  Dir.foreach(dir) do |f|
    if not f =~ /\.?\.$/ then
      filename = File.join(dir, f)
      if File.directory?(filename) then
        rm_rf(filename)
      else
        puts "Removing file #{filename}"
        File.rm_f(filename)
      end
    end
  end
  puts "Removing directory #{dir}"
  Dir.rmdir(dir)
end

Find.find('.') do |file|
  if File.directory?(file) then
    case file
      when /\/CVS$/
        # Remove CVS directories
        rm_rf(file)
      else
        # Remove empty directories
        entries = Dir.entries(file)
        entries.delete('.')
        entries.delete('..')
        entries.delete('CVS')
        if entries.length == 0 then
          rm_rf(file)
        end
    end
  else
    case file
      when /\.rb$/
        # Add LICENSE to ruby sources
        puts "Adding license to #{file}"
        lines = ruby_license_comment + IO.readlines(file)
        File.open(file, 'w') do |out|
          lines.each do |line|
            out.puts line
          end
        end
      when /\.c$/
        # Add LICENSE to C sources
        puts "Adding license to #{file}"
        lines = c_license_comment + IO.readlines(file)
        File.open(file, 'w') do |out|
          lines.each do |line|
            out.puts line
          end
        end
      when /~$/
        # Remove temporary files
        puts "Removing file #{file}"
        File.rm_f(file)
    end
  end
end

