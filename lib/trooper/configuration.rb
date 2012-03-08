# encoding: utf-8

require 'trooper/arsenal'

require 'trooper/config/environment'
require 'trooper/config/strategy'
require 'trooper/config/action'

module Trooper
  class Configuration
    FILE_NAME = "Troopfile"

    include Trooper::Config::Environment
    include Trooper::Config::Strategy
    include Trooper::Config::Action

    # def self.init
    # end
    
    def initialize(options = {})
      @data = {}
      @loaded = false
      @file_name = options[:file_name] || FILE_NAME
      @data[:environment] = options[:environment] || :production

      load_troopfile! options
    end 

    # def execute(strategy_name)
    #   Arsenal.strategies[strategy_name].execute self
    # end

    def set(hash)
      merge_with_data hash
    end

    def loaded?
      @loaded
    end

    def [](key)
      @data[key]
    end

    private

    def merge_with_data(options)
      @data.merge! options
    end

    def load_troopfile!(options)
      if troopfile?
        eval troopfile.read
        @loaded = true
        
        load_environment!
        merge_with_data options
      else
        raise Trooper::NoConfigurationFileError, "No Configuration file (#{@file_name}) can be found!"
      end
    end

    def load_environment!
      instance_variable = instance_variable_get("@#{@data[:environment].to_s}_configuration")
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