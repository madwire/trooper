require 'trooper/action'

module Trooper
  module Actions

    class CloneRepositoryAction < Action

      def initialize(config = {})
        @name = :clone_repository
        @description = "Cloning repository as 'application'"
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
        cd path
        run "git clone #{repository} application"
      end
      
    end

  end
end