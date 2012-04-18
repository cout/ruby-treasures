# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'ds_test_helpers'
require 'expect'
require 'reactor/select_reactor'

class ExpectTest < RUNIT::TestCase
  def setup
    @reactor = SelectReactor.new
    @read, @write = IO.pipe
    @expect = Expect.new(@read, @reactor)
    @expect.timeout = 1
  end

  def test_simple
    @write.puts "testing..."
    @expect.expect "testing..."
    @expect.run
  end

  def test_regex
    @write.puts "testing..."
    @expect.expect /est/
    @expect.run
  end

  def test_timeout
    @expect.expect "testing..."
    assert_exception(Expect::Timeout) do
      @expect.run
    end
  end

  def test_unmatched_message
    @write.puts "hmm..."
    @expect.expect("..........")
    assert_exception(Expect::UnmatchedMessage) do
      @expect.run
    end
  end

  def test_ignore
    @write.puts "testing"
    @write.puts "ignore"
    @expect.expect "testing"
    @expect.ignore "ignore"
    @expect.run
  end

  def test_reset
    @write.puts "testing..."
    @expect.expect "testing..."
    @expect.run

    @expect.reset
    @expect.run

    @write.puts "test2"
    @expect.expect "test2"
    @expect.run
  end

  def test_multiple_chains
    @expect.expect "testing...", :chain1
    @expect.expect "hmm...", :chain2
    @write.puts "testing..."
    @write.puts "hmm..."
    @expect.run

    @expect.expect "testing...", :chain1
    @expect.expect "hmm...", :chain2
    @write.puts "hmm..."
    @write.puts "testing..."
    @expect.run
  end
end

exit run_test(ExpectTest)

