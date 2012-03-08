module Trooper
  
  class Arsenal < Array

    def find_by_name(name)
      detect { |weapon| weapon.name == name }
    end
    alias :[] :find_by_name

    def add(weapon)
      if weapon.ok?
        remove weapon.name
        self << weapon 
      end
      weapon
    end

    def remove(name)
      self.delete_if {|w| w.name == name}
    end

    def clear!
      self.clear
    end

    class << self

      def strategies
        @strategies ||= new
      end

      def actions
        @actions ||= new
      end

      def reset!
        @strategies, @actions = nil
      end

    end
    
  end

end