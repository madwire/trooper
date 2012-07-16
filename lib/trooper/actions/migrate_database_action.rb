require 'trooper/actions/default_action'

module Trooper
  module Actions

    class MigrateDatabaseAction < DefaultAction
      name :migrate_database
      description "Migrating database"

      private

      def build_commands
        cd application_path
        rake "db:migrate RAILS_ENV=#{environment}"
      end
      
    end

  end
end