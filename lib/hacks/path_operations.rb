# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
##
# Determine the "real" name of a file.
#
# On Win32 (and other platforms that don't support symlinks), this should
# return whatever was passed (similar to the "truename" command on DOS, but
# at the moment doesn't handle subst'd drives).
#
# On Unix, this will break the filename into pieces and remove all symlinks
# from the filename.  It does not handle hard links.
#
# @param file the filename to process.
#
# @return the "real" name of the passed filename.
# 
def realpath(file)
  if not File.respond_to?(:readlink) then
    return file
  end

  total = ''
  File.expand_path(file).split(File::SEPARATOR).each do |piece|
    next if piece == ""
    if File.symlink?(total + File::SEPARATOR + piece) then
      total += File::SEPARATOR + piece
      begin
        total =  File.expand_path(
            File.readlink(total),
            File.dirname(total))
      end while File.symlink?(total)
    else
      total << File::SEPARATOR + piece
    end
  end

  return total
end

##
# Given a filename, search for it in path.
#
# @param file the name of the file to find
# @param path an array containing all the directories to search
# @param extensions an array containing extensions to search for
#
# @return the full pathname of the file, or just the parameter file if it
# was not found.
#
def find_file_in_path(file, path=$:, extensions=['', '.so', '.rb'])
  path.each do |dir|
    pathname = File.join(dir, file)
    filenames = []
    extensions.each do |ext|
      filenames.push(pathname + ext)
    end
    filenames.each do |pathname|
      if File.exists?(pathname) then
        return File.expand_path(pathname)
      end
    end
  end
  return file
end

