module Trooper
  
  class Strategies < Array

    def find_by_name(name)
      detect { |strategy| strategy.name == name }
    end

    class << self

      def [](name)
        strategies.find_by_name name
      end

      def add(strategy)
        if strategy.ok?
          remove strategy.name
          strategies << strategy 
        end
        strategy
      end

      def strategies
        @strategies ||= new
      end

      def remove(name)
        strategies.delete_if {|s| s.name == name}
      end

      def clear!
        strategies.clear
      end

    end
    
  end

end