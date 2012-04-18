# Ruby Treasures 0.4
# Copyright (C) 2002 Paul Brannan <paul@atdesk.com>
# 
# You may distribute this software under the same terms as Ruby (see the file
# COPYING that was distributed with this library).
# 
##
# A simple state machine.
#
# <pre>
#   sm = State_Machine.new(
#       {
#         :ALPHA => {
#           :A => :ALPHA,
#           :B => :BETA
#         },
#         :BETA => {
#           :A => :ALPHA
#         }
#       },
#       :ALPHA
#   )
# 
#   sm.change_state(:A)
#   sm.change_state(:B)
# </pre>
#
# Note that you are not limited to using symbols as your states and inputs;
# you may use any object type you wish (RubyCollections Enums work well).
#
class StateMachine
  class InvalidInput < Exception
  end

  attr_reader :state

  ##
  # Create a new state machine.
  #
  # @param states a hash: { current_state => { input => new_state } }
  # @param initial state the initial state
  #
  def initialize(states, initial_state)
    @states = states
    @state = initial_state
  end

  ##
  # Change state to whichever state is associated with the given input.
  #
  def change_state(input)
    valid_inputs = @states[@state]
    if not valid_inputs or not (new_state = valid_inputs[input]) then
      raise(
          InvalidInput,
          "#{input} not valid in state #{@state}")
    end
    @state = new_state
  end

  ##
  # Write a picture of the state machine to a file, using GraphR.
  #
  # @param orientation a string, 'portrait' or 'landscape'.
  # @param file the name of the file to write to.
  # @param args any additional arguments you wish to pass to write_to_file.
  #
  def draw(orientation, file, *args)
    require 'graph/graphviz_dot'
    links = []
    @states.each do |state, transitions|
      transitions.each do |input, new_state|
        links.push([state.to_s, new_state.to_s, input.to_s])
      end
    end
    dgp = DotGraphPrinter.new(links)
    dgp.node_shaper = proc { 'circle' }
    # dgp.set_node_attributes # TODO
    dgp.orientation = orientation
    dgp.write_to_file(file, *args)
  end
end

##
# A special type of state machine that keeps a history of all inputs and
# states.
#
class RecordKeepingStateMachine < StateMachine
  attr_reader :state_history
  attr_reader :input_history

  def initialize(states, initial_state)
    super(states, initial_state)
    @state_history = [initial_state]
    @input_history = []
  end

  def change_state(input)
    super(input)
    @state_history.push(@state)
    @input_history.push(input)
  end
end

