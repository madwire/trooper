require 'trooper/action'

module Trooper
  module Actions

    class SetupTrooperAction < Action

      def initialize(config = {})
        @name = :setup_trooper
        @description = "Setup Trooper"
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
        create_folders path, trooper_path
        run 'echo -e "Trooper Setup on Server!"'
      end
      
    end

  end
end