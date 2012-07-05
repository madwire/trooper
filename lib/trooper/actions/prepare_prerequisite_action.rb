require 'trooper/action'

module Trooper
  module Actions

    class PreparePrerequisiteAction < Action

      def initialize(config = {})
        @name = :prepare_prerequisite
        @description = "Preparing Prerequisites"
        @config = config
        @commands = []
      end

      def call(configuration)
        @config = configuration
        @commands = []

        build_commands
        commands
      end

      private

      def build_commands
        create_folders trooper_path
        run "echo '#{@name}' >> #{prerequisite_list}"
        run 'echo -e "Prerequisites Prepared"'
      end
      
    end

  end
end