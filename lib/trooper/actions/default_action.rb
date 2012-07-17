require 'trooper/action'

module Trooper
  module Actions

    class DefaultAction < Action

      class << self
        attr_accessor :config

        %w(name description options).each do |method|
          define_method(method) do |value| 
            self.config = {} unless self.config
            self.config[method.to_sym] = value
          end
        end
      end

      def initialize(config = {})
        @name = self.class.config[:name]
        @description = self.class.config[:description]
        @options = self.class.config[:options] || {}
        @config = config
        @call_count = 0
        @commands = []
      end

      # Always returns true because default actions are 
      # loaded before the troopfile, so varibles will 
      # always be missing.
      def ok?
        true
      end

      private

      def build_commands
        nil
      end
      
    end

  end
end