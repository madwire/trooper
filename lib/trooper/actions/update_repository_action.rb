require 'trooper/actions/default_action'

module Trooper
  module Actions

    class UpdateRepositoryAction < DefaultAction
      name :update_repository
      description "Updating repository"

      private

      def build_commands
        cd application_path
        run "git checkout #{branch} -q"
        run "git pull origin #{branch} -q"
        run "git gc --aggressive"
      end

      def branch
        config[:branch] || 'master'
      end
      
    end

  end
end