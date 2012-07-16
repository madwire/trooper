require 'trooper/actions/default_action'

module Trooper
  module Actions

    class InstallGemsAction < DefaultAction
      name :install_gems
      description "Installing Gems with Bundler"

      private

      def build_commands
        cd application_path
        bundle_install
      end
      
    end
    
  end
end