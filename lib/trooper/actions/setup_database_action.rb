require 'trooper/action'

module Trooper
  module Actions

    class SetupDatabaseAction < Action

      def initialize(config = {})
        @name = :setup_database
        @description = "Setting up database"
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
        rake "db:setup RAILS_ENV=#{environment}"
      end
      
    end

  end
end