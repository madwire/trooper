require 'trooper/action'

module Trooper
  module Config
    module Action
      
      def action(name, description = "No Description", &block)
        action = Trooper::Action.new name, description, self, &block
        Trooper::Arsenal.actions.add action
      end

    end
  end
end