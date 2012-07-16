require 'trooper/actions/default_action'

module Trooper
  module Actions

    class SetupTrooperAction < DefaultAction
      name :setup_trooper
      description "Setup Trooper"

      private

      def build_commands
        create_folders path, trooper_path
        run 'echo -e "Trooper Setup on Server"'
      end
      
    end

  end
end