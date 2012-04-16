module Trooper
  
  class Arsenal < Array

    # find an arsenal by its name
    def find_by_name(name)
      detect { |weapon| weapon.name == name }
    end
    alias :[] :find_by_name

    # add a weapon to the arsenal
    def add(weapon)
      if weapon.ok?
        remove weapon.name
        self << weapon 
      end
      weapon
    end

    # remove a weapon from the arsenal
    def remove(name)
      self.delete_if {|w| w.name == name}
    end

    # clears arsenal
    def clear!
      self.clear
    end

    class << self

      # returns the strategies arsenal
      def strategies
        @strategies ||= new
      end

      # returns the strategies arsenal
      def actions
        @actions ||= new
      end

      # clears all default arsenal
      def reset!
        @strategies, @actions = nil
      end

    end
    
  end

end