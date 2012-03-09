require 'trooper/action'

module Trooper
  module Actions

    class InstallGemsAction < Action

      def initialize(config = {})
        @name = :install_gems
        @description =  "Installing Gems with Bundler"
        @config = config
        @commands = []

        build_commands
      end

      private

      def build_commands
        cd application_path
        bundle_install
      end
      
    end
    
  end
end