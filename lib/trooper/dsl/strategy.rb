require 'trooper/strategy'

module Trooper
  module DSL
    module Strategy
      
      def strategy(name, description = "No Description", &block)
        strategy = Trooper::Strategy.new name, description, &block
        Trooper::Strategies.add strategy
      end

    end
  end
end