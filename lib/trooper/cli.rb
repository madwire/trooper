require 'optparse'

module Trooper
	class CLI

		def self.start(argv = ARGV)
			cli = self.new(argv)
			cli.execute
			cli
		end

		attr_reader :strategy, :environment, :options, :argv

		def initialize(argv)
			@argv = argv
			@options = {}
			@strategy, @environment = option_parser.parse!(@argv)

			raise CliArgumentError, "You didnt pass a strategy" if @strategy == nil
		end

		def execute
			nil
		end

		private

		def option_parser
			@option_parser ||= ::OptionParser.new do |op|
    		op.banner = 'Usage: trooper <strategy> <environment> [options]'      
    		op.separator ''

    		op.on "-d", "--debug", "Debuy" do 
    			@options[:debug] = true
    		end

    		op.on_tail "-h", "--help", "Help" do 
		    	puts @option_parser
		    	exit
		    end

	      op.on_tail "--version", "Show version" do
	        puts Trooper::Version::STRING
	        exit
	      end

    	end
		end

	end
end