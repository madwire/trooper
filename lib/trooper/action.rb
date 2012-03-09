require 'trooper/dsl/folders'
require 'trooper/dsl/rake'
require 'trooper/dsl/bundler'

module Trooper
  class Action
    include Trooper::DSL::Folders
    include Trooper::DSL::Rake
    include Trooper::DSL::Bundler

    attr_reader :name, :description, :config
    attr_accessor :commands

    def initialize(name, description, config = {}, &block)
      @name, @description, @config = name, description, config
      @commands = []
      @loaded = false
      eval_block(&block)
    end

    def ok?
      @loaded
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
       @loaded = true
    end

  end
end