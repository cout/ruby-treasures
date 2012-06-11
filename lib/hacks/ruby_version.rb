# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'rbconfig'

class RubyVersion
  include Comparable

  attr_reader :major
  attr_reader :minor
  attr_reader :teeny

  def initialize(*args)
    case args.size
    when 1
      if args[0] =~ /(\d+)\.(\d+)\.(\d+)/ then
        @major = $1.to_i
        @minor = $2.to_i
        @teeny = $3.to_i
      else
        raise "Incorrectly formatted version string: #{args[0].inspect}"
      end
    when 3
      @major = args[0].to_i
      @minor = args[1].to_i
      @teeny = args[2].to_i
    else
      raise ArgumentError, "Wrong number of arguments (#{args.size})"
    end
  end

  def self.current(*args)
    major = Config::CONFIG['MAJOR'].to_i
    minor = Config::CONFIG['MINOR'].to_i
    teeny = Config::CONFIG['TEENY'].to_i
    return self.new(major, minor, teeny)
  end

  def to_a
    return [major, minor, teeny]
  end

  def to_s
    return "#{major}.#{minor}.#{teeny}"
  end

  def <=>(other)
    if other.respond_to?(:major) and
       other.respond_to?(:minor) and
       other.respond_to?(:teeny) then
      if (compare = @major <=> other.major) == 0 then
        if (compare = @minor <=> other.minor) == 0 then
          compare = @teeny <=> other.teeny
        end
      end
      return compare
    else
      return self <=> RubyVersion.new(other)
    end
  end
end

