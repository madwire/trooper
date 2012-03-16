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

    def initialize(name, description, &block)
      @name, @description, @config = name, description, {}
      @commands, @block = [], block
    end

    def call(configuration)
      @config = configuration
      eval_block(&block)
      commands
    end

    def ok?
      true
    end

    def run(command)
      commands << command if command != ''
    end

    def method_missing(method_sym, *arguments, &block)
      config[method_sym] || super
    end

    private

    def eval_block(&block)
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