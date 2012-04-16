# encoding: utf-8

require 'trooper/arsenal'

require 'trooper/config/environment'
require 'trooper/config/strategy'
require 'trooper/config/action'

module Trooper
  class Configuration < Hash
    FILE_NAME = "Troopfile"

    include Trooper::Config::Environment
    include Trooper::Config::Strategy
    include Trooper::Config::Action

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
    
    # initialize a new configuration object, will parse the given troopfile.
    #   Configuration.new({:my_override => 'settings'})
    def initialize(options = {})
      @loaded = false
      @file_name = options[:file_name] || FILE_NAME
      self[:environment] = options[:environment] || :production

      load_default_actions!
      load_troopfile! options
    end

    # returns a terminal friendly version of the configuration 
    def to_s
      self.map {|k,v| "#{k}: #{v}" }.join("\n")
    end

    # will find and execute the strategy name passed
    #   @config.execute(:my_strategy_name)
    def execute(strategy_name)
      Arsenal.strategies[strategy_name].execute self
    end

    # a way to set variables that will be available to all actions
    #   set(:my_variable => 'sdsd') # => available as method in an action
    def set(hash)
      self.merge! hash
    end

    # returns true if the troopfile was loaded
    def loaded?
      @loaded
    end

    private

    # loads the troopfile and sets the environment up
    def load_troopfile!(options)
      if troopfile?
        eval troopfile.read
        @loaded = true
        
        load_environment!
        set options
      else
        raise Trooper::NoConfigurationFileError, "No Configuration file (#{@file_name}) can be found!"
      end
    end

    # returns the troopfile file object
    def troopfile
      File.open(@file_name)
    end
    
    # returns true if the troopfile exists
    def troopfile?
      File.exists?(@file_name)
    end

  end
end