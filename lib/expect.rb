# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
##
# Given an IO object, read data from that object and expect certain data.
#
# All expected data is expected in 'chains'.  When a message is received, it
# is compared to the pattern at the top of each chain.  If it matches one of
# the patterns, then all is well, but an error message is printed otherwise.
#
# A message can match patterns in more than one chain.
#
class Expect
public

  class UnmatchedMessage < Exception
    attr_reader :msg

    def initialize(msg)
      @msg = msg
      super("Message not matched: `#{msg}'")
    end
  end

  class Timeout < Exception
    attr_reader :chain
    attr_reader :pattern

    def initialize(chain, pattern)
      @chain = chain
      @pattern = pattern
      
      super("Timed out waiting for #{pattern.inspect} in chain #{chain.inspect}")
    end
  end

  ##
  # A special type of pattern that matches a list of patterns, separated
  # by a given separator, in any order.
  #
  # Example:
  # <pre>
  #   # matches 'foo,bar' and 'bar,foo'
  #   p = SeparatorPattern.new(['foo', 'bar'])
  #   
  #   e = Expect.new(nil, nil)
  #   e.expect(p)
  # </pre>
  #
  class SeparatedPattern
    attr_accessor :separator

    def initialize(message, separator = ',')
      @message = message
      @separator = separator
    end

    def ===(line)
      message = @message.dup

      # Iterate through each field to make sure it matches.  When
      # we find a match, delete that field so we never check it
      # again.
      for field in fields do
        message.each_index do |index|
          if message[index] === field then
            message.delete_at(index)
          end
        end
      end

      # If there are no more fields, then we deleted all of them,
      # and we got a match
      return message.length == 0
    end
  end

  class DefaultChain
  end

  ##
  # It is highly recommended that this be an immutable object.
  #
  attr_accessor :timeout

  ##
  # Create a new Expect_Test object.
  #
  # @param io_object an IO object to read from.
  # @param reactor a reactor to use
  #
  def initialize(io_object, reactor)
    @io_object = io_object
    @reactor = reactor
    @reactor.register_read(@io_object, method(:handle_event))
    @timeout = nil
    reset()
  end

  ##
  # Reset the the ignore chain and all expect chains.
  #
  def reset()
    @expect_chain = Hash.new
    @ignore_chain = Array.new
    @expects_left = 0
  end

  ##
  # Expect a message matching pattern in a certain chain.
  #
  # @param pattern the pattern to expect.
  # @param chain the chain in which to expect the message.
  #
  def expect(pattern, chain=DefaultChain)
    @expect_chain[chain] ||= Array.new
    @expect_chain[chain].push(pattern)
    @expects_left += 1
  end

  ##
  # Ignore a pattern in all chains.
  #
  # @param pattern the pattern to ignore.
  #
  def ignore(pattern)
    @ignore_chain.push(pattern)
  end

  def run
    return if @expects_left == 0
    catch :expect_loop_done do
      @reactor.run_event_loop(@timeout)
      for key, chain in @expect_chain do
        next if chain.length == 0
        raise Timeout.new(key, chain.first)
      end
      # TODO: What does it mean if we got here?
    end
  end

  def handle_event(io_object)
    handle_line(io_object.gets())
  end

  def handle_line(line)
    line.chomp!()

    # Check each element in the ignore chain
    for pattern in @ignore_chain do
      return if pattern === line
    end

    # Check the first element of each expect chain to see if
    # the message matches
    match = false
    for key, chain in @expect_chain do
      next if chain.length == 0
      if chain.first() === line then
        chain.shift()
        @expects_left -= 1
        match = true
      end
    end

    throw :expect_loop_done if @expects_left == 0

    raise UnmatchedMessage.new(line) if match == false
  end
end

