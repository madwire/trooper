require 'trooper/actions/default_action'

module Trooper
  module Actions

    class PreparePrerequisiteAction < DefaultAction
      name :prepare_prerequisite
      description "Preparing Prerequisites"

      private

      def build_commands
        create_folders trooper_path
        run "echo '#{@name}' >> #{prerequisite_list}"
        run 'echo -e "Prerequisites Prepared"'
      end
      
    end

  end
end