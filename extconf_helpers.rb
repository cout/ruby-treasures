# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
TARGETS = [
  # target name  |  phony?
  [ 'all',          true  ],
  [ 'clean',        true  ],
  [ 'distclean',    true  ],
  [ 'realclean',    true  ],
  [ 'install',      true  ],
  [ 'site-install', true  ],
]

IGNOREDIRS = [
  '.',
  '..',
  'CVS'
]

def ignoredir(file)
  return true if not FileTest.directory?(file)
  return true if FileTest.symlink?(file)
  return IGNOREDIRS.index(file)
end

def recurse_extdirs
  erl = 'extconf_recursion_level'
  if not ENV[erl]
    ENV[erl] = '1'
  end
  EXTDIRS.each do |dir|
    if not ignoredir(dir) then
      puts "#{$0}[#{ENV[erl]}]: Entering directory #{dir}"
      Dir.chdir dir
      if FileTest.exist?('extconf.rb') then
        erl_save = ENV[erl]
        ENV[erl] = ENV[erl].succ
        system 'ruby extconf.rb'
        ENV[erl] = erl_save
      end
      puts "#{$0}[#{ENV[erl]}]: Leaving directory #{dir}"
      Dir.chdir '..'
    end
  end
end

def generate_makefile
  puts 'Creating Makefile'
  File.open('Makefile', 'w') do |mfile|
    phony_targets = []
    TARGETS.each do |target, phony|
      if phony then
        phony_targets << target
      end
      mfile.puts "#{target}:"

      if defined?(MAKEFILES) then
        MAKEFILES.each do |makefile|
          mfile.puts "\tmake -f #{makefile} #{target}"
        end
      end

      if defined?(MAKEDIRS) then
        MAKEDIRS.each do |dir|
          if FileTest.exist?("#{dir}/Makefile") or
             FileTest.exist?("#{dir}/makefile") then
            mfile.puts "\tMAKEFILE=Makefile make -C #{dir} -f Makefile #{target}"
          end
        end
      end

      mfile.puts ""
    end
    mfile.puts ".PHONY : #{phony_targets.join(' ')}"
    mfile.puts ""

    # TODO: Remove MAKEFILES
  end
end

def append_makefile(str=nil)
  File.open('Makefile', 'a') do |mfile|
    if block_given? then
      str = yield str
    end
    mfile << str
  end
end

