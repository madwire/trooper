require 'trooper/action'

module Trooper
  module Actions

    class MigrateDatabaseAction < Action

      def initialize(config = {})
        @name = :migrate_database
        @description = "Migrating database"
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
        rake "db:migrate RAILS_ENV=#{environment}"
      end
      
    end

  end
end