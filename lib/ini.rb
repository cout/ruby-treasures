# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'loaders'
requirelocal 'io_helper'

##
# An INI_Importable can only import INI files and read from the data that was
# read; there is no interface for writing to the data.
#
module INI_Importable
  class Section
    def initialize(data)
      @data = data
    end

    def [](key)
      return @data[key]
    end
  end
  
  def import(ini_file)
    current_section = nil
    lines = ini_file.readlines
    lines.each do |line|
      case line
      when "\s*#"
        # comment
      when "\s*\[(\w+)\]"
        # section
        $1.freeze
        section = $1
        current_section = @data[section] = Hash.new
      when "\s*(\w+)\s*=\s*(.*)"
        # key=value
        if not current_section then
          raise "Key/value pair found outside of section"
        end
        $1.freeze
        $2.freeze
        current_section[$1] = $2
      end
    end
  end

  def [](section_name)
    return Section.new(@data[section_name])
  end
end

##
# An INI_Exportable can hold data for an INI file, read and write that data,
# and export the data.  There is no interface for importing an INI File.
#
module INI_Exportable
  class Section < INI_Importable::Section
    def []=(key, value)
      @data[key] = value
    end
  end

  def export(ini_file)
    File.open(ini_file, 'w') do |output|
      @data.each do |section_name, section|
        output.puts "[#{section_name}]"
        section.each do |key, value|
          output.puts "#{key}=#{value}"
        end
      end
    end
  end

  def new_section(section_name)
    @data[section_name] = Hash.new
    return self[section_name]
  end

  def [](section_name)
    return Section.new(@data[section_name])
  end
end

##
# An INI Reader is an INI_Importable.
#
class INI_Reader
  include INI_Importable
  
  def initialize(ini_file)
    @data = Hash.new
    import(ini_file)
  end
end

##
# An INI Writer is an INI_Exportable.
#
class INI_Writer
  include INI_Exportable

  def initialize()
    @data = Hash.new
  end
end

##
# An INI Object is both an INI_Importable and an INI_Exportable.
#
class INI < INI_Reader
  include INI_Exportable
end

