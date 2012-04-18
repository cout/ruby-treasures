# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'loaders'
require 'pstore'
require 'rbconfig'
requirelocal 'caller_helpers'

##
# A hack for allowing inline C code inside a Ruby program.
#
module Inline
  @@files_to_update = Hash.new

  CONFIG = Config::CONFIG

  CFLAGS =
    "-I#{CONFIG['archdir']} -I#{CONFIG['includedir']}"

  LDFLAGS =
    "-L#{CONFIG['libdir']} -L#{CONFIG['archdir']} " +
    "#{CONFIG['LIBS']} #{CONFIG['LDFLAGS']} -lruby"

  CC = 'gcc'

  ##
  # A helper function for checking dependencies.  Calls the block if
  # the target is out of date.
  #
  def self.check_dependency(target, dependency, &block)
    if not FileTest.exists?(target) then
      block.call
    else
      target_ctime = File.stat(target).ctime
      dependency_ctime = File.stat(dependency).ctime
      if target_ctime <= dependency_ctime then
        block.call
      end
    end
  end

  ##
  # Put inline code in another language inside a Ruby script.
  #
  # @param lang The language of the source (currently must be "C")
  # @param source The source to inline
  #
  # TODO: For now, you must have an Init_filename function in your C code,
  # where filename is the name of your Ruby script (minus the .rb extension).
  # This function could be automatically generated in the future.
  #
  # TODO: Currently, this just checks dates to see if the Ruby file has been
  # modified, and if so, it recompiles.  Ideally, MD5 or some other
  # mechanism should be used to see if the inline source has changed, so that
  # the Ruby script can be modified without recompiling (I'm told that this
  # is what the Perl inline module does).
  # 
  # TODO: CFLAGS and LDFLAGS should be configurable.
  #
  # E.g.:
  # <pre>
  #   Inline.inline "C", <<END
  #   #include &lt;stdio.h&gt;
  #
  #   void Init_inline_helper() {
  #     printf("hello, world!\n");
  #   }
  #
  #   END
  #
  #   Inline::require
  # </pre>
  #
  def self.inline(lang, source, level = 0)
    if lang != "C" then
      raise ArgumentError, "Unsupported language: #{lang}"
    end
    
    begin
      Thread.critical = true

      filename, lineno, method = parse_caller(caller[level])
      full_filename = caller_file_pathname(filename)
      helper_filename = strip_extension(full_filename) + "_helper.c"

      if not FileTest.exists?(full_filename) then
        raise RuntimeError, "Cannot determine modification time of source"
      end

      check_dependency(helper_filename, full_filename) do
        if FileTest.exists?(helper_filename) then
          File.delete(helper_filename)
        end
        @@files_to_update[helper_filename] = true
      end

      if @@files_to_update.has_key?(helper_filename) then
        File.open(helper_filename, "a") do |helper|
          helper.puts(source)
        end
      end

      build(lang, level + 1)
    
    ensure
      Thread.critical = false
    end
  end

  ##
  # Explicitly build the _helper.so file from the source.  You do not
  # normally need to call this method.
  #
  # @param lang the language of the source
  # 
  def self.build(lang="C", level = 0)
    if lang != "C" then
      raise ArgumentError, "Unsupported language: #{lang}"
    end

    filename, lineno, method = parse_caller(caller[level])
    full_filename = caller_file_pathname(filename)
    helper_filename = strip_extension(full_filename) + "_helper.c"
    helper_soname = strip_extension(full_filename) + "_helper.so"

    rebuild = false
    check_dependency(helper_soname, helper_filename) do
      rebuild = true
    end

    if rebuild then
      puts "Rebuilding #{helper_soname}"
      system("#{CC} #{CFLAGS} #{LDFLAGS} #{helper_filename} -shared -o #{helper_soname}")
    end
  end

  ##
  # Automatically require the _helper.so file.
  #
  def self.require
    filename, lineno, method = parse_caller(caller[0])
    full_filename = caller_file_pathname(filename)
    helper_soname = strip_extension(full_filename) + "_helper.so"
    eval "require '#{helper_soname}'", TOPLEVEL_BINDING, __FILE__
  end

  ##
  # Clean the _helper.c and _helper.so files
  #
  def self.clean(lang="C")
    if lang != "C" then
      raise ArgumentError, "Unsupported language: #{lang}"
    end

    filename, lineno, method = parse_caller(caller[0])
    full_filename = caller_file_pathname(filename)
    helper_filename = strip_extension(full_filename) + "_helper.c"
    helper_soname = strip_extension(full_filename) + "_helper.so"

    File.delete(helper_filename)
    File.delete(helper_soname)
  end

  ##
  # For internal use only.
  #
  def self.strip_extension(filename)
    if filename =~ /(.*)\.[^\.]*$/ then
      return $1
    end
    return filename
  end
end # module Inline

