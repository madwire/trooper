require 'trooper/action'

module Trooper
  module Actions

    class RestartServerAction < Action

      def initialize(config = {})
        @name = :restart_server
        @description = "Restart server"
        @config = config
        @commands = []
      end

      def call(configuration)
        @config = configuration
        build_commands
        commands
      end

      private

      def build_commands
        cd application_path
        create_folder 'tmp'
        run 'touch tmp/restart.txt'
        run 'echo -e "Server restarted!"'
      end
      
    end

  end
end