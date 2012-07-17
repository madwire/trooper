require 'trooper/dsl/folders'
require 'trooper/dsl/rake'
require 'trooper/dsl/bundler'

module Trooper
  class Action
    include Trooper::DSL::Folders
    include Trooper::DSL::Rake
    include Trooper::DSL::Bundler

    attr_reader :name, :description, :config, :block, :options
    attr_accessor :commands

    # Public: Define a new action.
    #
    # name - The name of the action.
    # description - A description of action to be used in the cli output.
    # options - The Hash options used to refine the selection (default: {}):
    #             :local - A boolean of whether this action should be run locally (optional).
    #             :on - A symbol(:first_host, :last_host) to determine if to run on the first or last host (optional).
    # block - A block containing the tasks to run in this action.
    #
    # Examples
    #
    #   Action.new(:my_action, 'Does great things') { run 'touch file' }
    #
    # Returns a new action object.
    def initialize(name, description, options = {}, &block)
      @name, @description, @options, @config = name, description, options, {}
      @call_count, @commands, @block = 0, [], block
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
      @call_count += 1

      if everything_ok? && continue_call?
        reset_commands!
        
        build_commands
        commands
      else
        reset_commands!
      end
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
 
    # Public: Validates the action object.
    #
    # Examples
    #
    #   @action.ok? # => true
    #
    # Returns true or raise an InvalidActionError exception.
    def ok?
      begin
        build_commands
        reset_commands!
        true
      rescue Exception => e
        raise InvalidActionError, "Action missing config variables - #{e.message}"
      end
    end
    alias :everything_ok? :ok?

    # Public: What type of action this is.
    #
    # Examples
    #
    #   @action.type # => :action
    #   @action.type # => :local_action
    #
    # Returns a Symbol.
    def type
      options && options[:local] ? :local_action : :action
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

    # Public: Resets Action commands to blank.
    #
    # Examples
    #
    #   @action.reset_commands! # => []
    #
    # Returns a blank array.
    def reset_commands!
      self.commands = []
    end

    def method_missing(method_sym, *arguments, &block) # :nodoc:
      config[method_sym] || super
    end

    private

    # builds commands array from block passed on init
    def build_commands
      eval_block(&block)
    end

    # determines whether to continue calling, to build the commands array
    def continue_call?
      if options && options[:on]
        
        case options[:on]
        when :first_host
          @call_count == 1
        when :last_host
          config[:hosts] && @call_count == config[:hosts].count
        else
          true
        end
      
      else
        true
      end
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