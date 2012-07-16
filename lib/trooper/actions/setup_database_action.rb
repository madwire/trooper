require 'trooper/actions/default_action'

module Trooper
  module Actions

    class SetupDatabaseAction < DefaultAction
      name :setup_database
      description "Setting up database"

      private

      def build_commands
        cd application_path
        rake "db:setup RAILS_ENV=#{environment}"
      end
      
    end

  end
end