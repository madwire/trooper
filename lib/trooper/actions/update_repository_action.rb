require 'trooper/action'

module Trooper
  module Actions

    class UpdateRepositoryAction < Action

      def initialize(config = {})
        @name = :update_repository
        @description = "Updating repository"
        @config = config
        @commands = []
      end

      def call(configuration)
        @config = configuration
        build_commands
        commands
      end

      private

      def build_commands
        cd application_path
        run "git checkout #{branch} -q"
        run "git pull origin #{branch} -q"
        run "git gc --aggressive"
      end
      
    end

  end
end