# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
require 'loaders'
requirelocal 'exception_extensions'

##
# A tool to annotate exceptions in Ruby.  This is (loosely) based on a
# C++ library discussed by Andrei Alexandrescu at the 2002 ACCU
# conference.
#
# E.g.:
# <pre>
#   begin
#     ExceptionAnnotator::operation("cleaning up...") do
#       ExceptionAnnotator::operation("writing logs...") do
#         ExceptionAnnotator::operation("opening log file...") do
#           raise "Unknown Error"
#         end
#       end
#     end
#   rescue Exception => exc
#     puts ExceptionAnnotator::annotated_mesg(exc)
#   end
# </pre>
#
# Will print:
# 
# <pre>
#   Unknown Error
#     while opening log file...
#     while writing logs...
#     while cleaning up...
# </pre>
#
module ExceptionAnnotator
  module ExceptionAnnotation
    attr_accessor :annotations

    def annotated_mesg()
      return self.to_s + "\n" +
             annotations.collect { |a| "  #{a}" }.join("\n") + "\n"
    end

    def annotate(msg)
      @annotations ||= Array.new
      @annotations.push(msg)
    end

    include ExceptionExtension
  end

  def self.operation(op, &block)
    begin
      yield
    rescue Exception => exc
      exc.extend(ExceptionAnnotation)
      exc.annotate("while #{op}")
      raise exc, exc.message, exc.backtrace
    end
  end

  def self.annotated_mesg(exc, default_annotation="** No annotation **")
    if exc.respond_to?(:annotated_mesg) then
      return exc.annotated_mesg
    else
      return exc.to_s + "\n  #{default_annotation}\n"
    end
  end
end

