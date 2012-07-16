require 'trooper/actions/default_action'

module Trooper
  module Actions

    class CloneRepositoryAction < DefaultAction
      name :clone_repository
      description "Cloning repository as 'application'"

      private

      def build_commands
        cd path
        run "git clone #{repository} application"
      end
      
    end

  end
end