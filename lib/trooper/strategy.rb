require 'trooper/host'

module Trooper
  class Strategy

    attr_reader :name, :description, :config, :run_list, :prereq_run_list, :block
    
    def initialize(name, description, config = {}, &block)
      @name, @description, @config = name, description, config
      @run_list, @prereq_run_list, @block = [], [], block
    end

    def build_execute_list(configuration)
      @config = configuration
      eval_block(&block)
      list
    end

    def ok?
      true
    end

    def call(*strategy_names)
      [*strategy_names].each do |strategy_name|
        if Arsenal.strategies[strategy_name]
          Arsenal.strategies[strategy_name].build_execute_list(config).each do |action|
            # strategy_name, type, name
            @run_list << action
          end
        end
      end
    end

    def prerequisites(*strategy_names)
      if @prereq_run_list == []
        @prereq_run_list = [[@name, :action, :prepare_prerequisite]]
      end

      [*strategy_names].each do |strategy_name|
        if Arsenal.strategies[strategy_name]
          Arsenal.strategies[strategy_name].build_execute_list(config).each do |action|
            # strategy_name, type, name
            @prereq_run_list << [action[0], :prerequisite, action[2]]
          end
        end  
      end
    end

    def actions(*action_names)
      [*action_names].each do |name| 
        # strategy_name, type, name
        @run_list << [self.name, :action, name]
      end
    end

    def list
      prereq_run_list + run_list
    end

    def method_missing(method_sym, *arguments, &block)
      config[method_sym] || super
    end

    private

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