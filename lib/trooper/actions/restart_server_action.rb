require 'trooper/actions/default_action'

module Trooper
  module Actions

    class RestartServerAction < DefaultAction
      name :restart_server
      description "Restart server"

      private

      def build_commands
        cd application_path
        create_folder 'tmp'
        run 'touch tmp/restart.txt'
        run 'echo -e "Server restarted!"'
      end
      
    end

  end
end