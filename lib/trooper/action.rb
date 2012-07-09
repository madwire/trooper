require 'trooper/dsl/folders'
require 'trooper/dsl/rake'
require 'trooper/dsl/bundler'

module Trooper
  class Action
    include Trooper::DSL::Folders
    include Trooper::DSL::Rake
    include Trooper::DSL::Bundler

    attr_reader :name, :description, :config, :block
    attr_accessor :commands

    # Public: Define a new action.
    #
    # name - The name of the action.
    # description - A description of action to be used in the cli output.
    # block - A block containing the tasks to run in this action.
    #
    # Examples
    #
    #   Action.new(:my_action, 'Does great things') { run 'touch file' }
    #
    # Returns a new action object.
    def initialize(name, description, &block)
      @name, @description, @config = name, description, {}
      @commands, @block = [], block
    end

    # Public: Eval's the block passed on initialize.
    #
    # configuration - The configuration object to be used for block eval.
    #
    # Examples
    #
    #   @action.call(config_object) # => ['touch file']
    #
    # Returns an array of commands(strings).
    def call(configuration)
      @config = configuration
      eval_block(&block)
      commands
    end
    alias :execute :call

    # Public: Modifies the commands list to include the prerequisite list checker .
    #
    # configuration - The configuration object to be used for block eval.
    #
    # Examples
    #
    #   @action.call(config_object) # => "..." 
    #
    # Returns a command String.
    def prerequisite_call(configuration)
      original_commands = call configuration
      original_commands << "echo '#{self.name}' >> #{prerequisite_list}"
      original_commands << "echo '#{self.description}'"
      "touch #{prerequisite_list}; if grep -vz #{self.name} #{prerequisite_list}; then #{original_commands.join(' && ')}; else echo 'Already Done'; fi" 
    end
 
    # Public: Validates the action object. (NOT WORKING)
    #
    # Examples
    #
    #   @action.ok? # => true
    #
    # Returns true.
    def ok?
      true
    end

    # run is the base run command used by the dsl

    # Public: Appends command(string) to commands(array).
    #
    # command - A String to be added to the commands array.
    #
    # Examples
    #
    #   @action.run 'touch file' # => 'touch file'
    #   @action.run '' # => nil
    #
    # Returns the command or nil.
    def run(command)
      commands << command if command != ''
    end

    def method_missing(method_sym, *arguments, &block) # :nodoc:
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