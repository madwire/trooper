#require 'trooper/dsl'

module Trooper
	class Configuration
		FILE_NAME = "Troopfile"

		# def self.init
		# end

		#attr_reader :file_name
    #attr_accessor :data
    attr_reader :data
		
		def initialize(options = {})
			@data = {}
			@loaded = false
			@file_name = options[:file_name] || FILE_NAME

			load_troopfile!
			merge_with_data options
		end 

		# def execute(strategy_name)
		# 	strategies[strategy_name].execute self
		# end

		def loaded?
			@loaded
		end

		def [](key)
			data[key]
		end

		private

		def load_troopfile!
      if troopfile?
        eval troopfile.read
        @loaded = true
      else
      	raise Trooper::NoConfigurationFileError, "No Configuration file (#{@file_name}) can be found!"
      end
		end

		def troopfile
			File.open(@file_name)
		end
      
    def troopfile?
      File.exists?(@file_name)
    end

    def merge_with_data(options)
			@data.merge! options
		end

	end
end