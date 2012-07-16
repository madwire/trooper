require 'trooper/actions/default_action'

module Trooper
  module Actions

    class RollbackMigrateAction < DefaultAction
      name :rollback_migrate
      description "Rollback database"
      
      private

      def build_commands
        cd application_path
        rake "db:rollback RAILS_ENV=#{environment}"
      end
      
    end

  end
end