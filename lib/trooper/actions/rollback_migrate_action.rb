require 'trooper/action'

module Trooper
  module Actions

    class RollbackMigrateAction < Action

      def initialize(config = {})
        @name = :rollback_migrate
        @description = "Rollback database"
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
        rake "db:rollback RAILS_ENV=#{environment}"
      end
      
    end

  end
end