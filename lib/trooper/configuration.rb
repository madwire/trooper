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

    # def self.init
    # end
    
    def initialize(options = {})
      @loaded = false
      @file_name = options[:file_name] || FILE_NAME
      self[:environment] = options[:environment] || :production

      load_default_actions!
      load_troopfile! options
    end 

    # def execute(strategy_name)
    #   Arsenal.strategies[strategy_name].execute self
    # end

    def set(hash)
      self.merge! hash
    end

    def loaded?
      @loaded
    end

    private

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

    def load_environment!
      instance_variable = instance_variable_get("@#{self[:environment].to_s}_configuration")
      unless instance_variable.nil?
        instance_eval(&instance_variable)
      end
    end

    def troopfile
      File.open(@file_name)
    end
      
    def troopfile?
      File.exists?(@file_name)
    end

  end
end