# encoding: utf-8

require 'trooper/arsenal'

require 'trooper/config/environment'
require 'trooper/config/strategy'
require 'trooper/config/defaults'

require 'trooper/runner'

module Trooper
  class Configuration < Hash

    include Trooper::Config::Environment
    include Trooper::Config::Strategy
    include Trooper::Config::Defaults

    # Public: Copies the template troopfile to current dir
    #
    # Examples
    #
    #   Configuration.init # => nil
    #
    # Returns nil.
    def self.init
      gem_dir = File.dirname(__FILE__)

      if RUBY_VERSION == /1.8/
        require 'ftools'
        File.copy("#{gem_dir}/template/troopfile.rb", "./Troopfile")
      else
        require 'fileutils'
        ::FileUtils.copy("#{gem_dir}/template/troopfile.rb", "./Troopfile")
      end
    end
    
    # Public: initialize a new configuration object, will parse the given troopfile
    #
    # options - Default options to combine with troopfile
    #
    # Examples
    #
    #   Configuration.new({:my_override => 'settings'}) # => <Configuration>
    #
    # Returns a configuration object.
    def initialize(options = {})
      @loaded = false

      load_defaults! options
      load_troopfile! options
    end

    # Public: Terminal Friendly version of the configuration.
    #
    # Examples
    #
    #   @configuration.to_s # => '...'
    #
    # Returns a String.
    def to_s
      config.map {|k,v| "#{k}: #{v}" }.join("\n")
    end

    # Public: Finds a Strategy and returns a runner for that strategy.
    #
    # strategy_name - The name of the strategy as a symbol.
    #
    # Examples
    #
    #   @config.runner(:my_strategy_name) # => <Runner>
    #
    # Returns a runner.
    def runner(strategy_name)
      strategy = Arsenal.strategies[strategy_name]
      Runner.new(strategy, self)
    end

    # Public: Set variables that will be available to all actions.
    #
    # hash - A key value hash to merge with config
    #
    # Examples
    #
    #   @config.set(:my_variable => 'sdsd') # => available as method in an action
    #
    # Returns self.
    def set(hash)
      config.merge! hash
    end

    # Public: Check to see if troopfile is loaded.
    #
    # Examples
    #
    #   @config.loaded? # => true
    #
    # Returns boolean.
    def loaded?
      @loaded
    end

    # Public: Will allow user in import another troopfile.
    #
    # Examples
    #
    #   @config.import('filename') # => nil
    #
    # Returns nil.
    def import(name)
      extname = File.extname(name).empty? ? ".rb" : nil
      filename =  File.join(troopfile_dir, "#{name}#{extname}")
      if File.exists?(filename)
        eval File.open(filename).read
        nil
      else
        raise Trooper::NoConfigurationFileError, "No Import Configuration file (#{self[:file_name]}) can be found!"
      end
    end

    private

    def config # :nodoc:
      self
    end

    # loads the troopfile and sets the environment up
    def load_troopfile!(options)
      if troopfile?
        eval troopfile.read
        @loaded = true
        
        load_environment!
        set options
      else
        raise Trooper::NoConfigurationFileError, "No Configuration file (#{self[:file_name]}) can be found!"
      end
    end

    # returns the troopfile file object
    def troopfile
      File.open(config[:file_name])
    end
    
    # returns true if the troopfile exists
    def troopfile?
      File.exists?(config[:file_name])
    end

    def troopfile_dir
      File.dirname(File.realpath(config[:file_name]))
    end

  end
end