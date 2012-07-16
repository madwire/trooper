require 'trooper/action'

module Trooper
  module Actions

    class DefaultAction < Action

      class << self
        attr_accessor :config

        %w(name description).each do |method|
          define_method(method) do |value| 
            self.config = {} unless self.config
            self.config[method.to_sym] = value
          end
        end
      end

      def initialize(config = {})
        @name = self.class.config[:name]
        @description = self.class.config[:description]
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
        nil
      end
      
    end

  end
end