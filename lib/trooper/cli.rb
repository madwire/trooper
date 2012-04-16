require 'optparse'
require 'trooper/configuration'

module Trooper
  class CLI

    def self.start(argv = ARGV)
      cli = self.new(argv)
      cli.execute
      cli
    end

    attr_reader :command, :options, :argv
    attr_accessor :config

    def initialize(argv)
      @argv = argv
      @options = { :environment => :production }

      @command = option_parser.parse!(@argv)[0]
      
      if @command 
        @command = @command.to_sym
      else
        raise CliArgumentError, "You didnt pass an action"
      end
    end

    def execute
      case command
      when :init
        Configuration.init
      else
        config = Configuration.new(options)
        config.execute command
      end
    end

    private

    def option_parser
      @option_parser ||= ::OptionParser.new do |op|
        op.banner = 'Usage: trooper <command> [options]'      
        op.separator ''

        op.on "-d", "--debug", "Debuy" do
          $trooper_log_level = ::Logger::DEBUG
          @options[:debug] = true
        end

        op.on "-e", "--env ENV", "Environment" do |e|
          @options[:environment] = e.to_sym
        end

        op.on "-f", "--file TROOPFILE", "Load a different Troopfile" do |f|
          @options[:file_name] = f || 'Troopfile' 
        end

        op.on_tail "-h", "--help", "Help" do 
          puts @option_parser
          exit
        end

        op.on_tail "-v", "--version", "Show version" do
          puts "Trooper v#{Trooper::Version::STRING}"
          exit
        end

      end
    end

  end
end