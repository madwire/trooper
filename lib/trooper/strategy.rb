require 'trooper/host'

module Trooper
  class Strategy

    attr_reader :name, :description, :config, :run_list, :prereq_run_list, :block
    
    # Public: Initialize a new Strategy object.
    #
    # name - A Symbol of the strategy name
    # description - A String of what this strategy will do.
    # config - A Hash of config options expects a Trooper::Configuration object
    # block - A block to be eval with the strategy object
    #
    # Examples
    #
    #   Strategy.new :my_strategy, 'Does something cool' do
    #     actions :my_action
    #   end
    #
    # Returns a Host object.
    def initialize(name, description, config = {}, &block)
      @name, @description, @config = name, description, config
      @run_list, @prereq_run_list, @block = [], [], block
    end

    # Public: Validates the strategy object. (NOT WORKING)
    #
    # Examples
    #
    #   @strategy.ok? # => true
    #
    # Returns true.
    def ok?
      true
    end

    # Public: Add other strategies actions to the run list.
    #
    # strategy_names - A list of other Strategy names.
    #
    # Examples
    #
    #   @strategy.call(:my_other_strategy) # => nil
    #
    # Returns nil.
    def call(*strategy_names)
      [*strategy_names].each do |strategy_name|
        if Arsenal.strategies[strategy_name]
          Arsenal.strategies[strategy_name].list(config).each do |action|
            # strategy_name, type, name
            @run_list << action
          end
        end
      end
    end

    # Public: Add other strategies actions to the prerequisite run list.
    #
    # strategy_names - A list of other Strategy names.
    #
    # Examples
    #
    #   @strategy.prerequisites(:my_other_strategy) # => nil
    #
    # Returns nil.
    def prerequisites(*strategy_names)
      if @prereq_run_list == []
        @prereq_run_list = [[@name, :action, :prepare_prerequisite]]
      end

      [*strategy_names].each do |strategy_name|
        if Arsenal.strategies[strategy_name]
          Arsenal.strategies[strategy_name].list(config).each do |action|
            # strategy_name, type, name
            @prereq_run_list << [action[0], :prerequisite, action[2]]
          end
        end  
      end
    end

    # Public: Add actions to the run list.
    #
    # action_names - A list of Action names.
    #
    # Examples
    #
    #   @strategy.actions(:my_action) # => nil
    #
    # Returns nil.
    def actions(*action_names)
      [*action_names].each do |name| 
        if Arsenal.actions[name]
          # strategy_name, type, name
          @run_list << [self.name, Arsenal.actions[name].type, name]
        end
      end
    end

    # Public: Add an Action to the Task list but scoped to this Strategy 
    # (Action Not available outside this object).
    #
    # name - The name of the action.
    # description - A description of action to be used in the cli output.
    # block - A block containing the tasks to run in this action.
    #
    # Examples
    #
    #   @strategy.action(:my_action, 'Does great things') { run 'touch file' }
    #
    # Returns an Action object.
    def action(name, description = "No Description", &block)
      action_name = "#{self.name}_#{name}".to_sym

      action = Trooper::Action.new action_name, description, &block
      Arsenal.actions.add action
      actions action_name
      
      action
    end

    # Public: The Task List.
    #
    # configuration - A optional Trooper::Configuration object.
    #
    # Examples
    #
    #   @strategy.list() # => [[:my_strategy, :action, :my_strategy_my_new_action]]
    #
    # Returns and Array of Arrays.
    def list(configuration = {})
      build_list(configuration) if run_list == []
      prereq_run_list + run_list
    end

    def method_missing(method_sym, *arguments, &block) # :nodoc:
      config[method_sym] || super
    end

    private

    # builds the task list by evaling the block passed on initialize
    def build_list(configuration)
      @config = configuration
      eval_block(&block)
    end

    def eval_block(&block) # :nodoc:
      if block_given?
        if block.arity == 1
          block.call self
        else
          instance_eval &block
        end
      end
    end

  end
end