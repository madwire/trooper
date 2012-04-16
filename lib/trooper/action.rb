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

    # expects a name, description and a block
    #   Action.new(:my_action, 'Does great things') { run 'touch file' }
    def initialize(name, description, &block)
      @name, @description, @config = name, description, {}
      @commands, @block = [], block
    end

    # eval's the block passed on initialize and returns the command array
    def call(configuration)
      @config = configuration
      eval_block(&block)
      commands
    end
    alias :execute :call

    # validates the action 
    def ok?
      true
    end

    # run is the base run command used by the dsl
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