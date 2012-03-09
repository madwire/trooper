require 'trooper/strategy'

module Trooper
  module Config
    module Strategy
      
      def strategy(name, description = "No Description", &block)
        strategy = Trooper::Strategy.new name, description, self, &block
        Trooper::Arsenal.strategies.add strategy
      end

    end
  end
end