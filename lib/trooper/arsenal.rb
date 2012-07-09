module Trooper
  
  class Arsenal < Array

    # Public: Find an item in the arsenal.
    #
    # name - The name of the weapon object, weapon object must respond to name.
    #
    # Examples
    #
    #   Arsenal.strategies.find_by_name(:my_stratergy) # => <Strategy>
    #   Arsenal.strategies[:my_stratergy] # => <Strategy>
    #
    # Returns the duplicated String.
    def find_by_name(name)
      detect { |weapon| weapon.name == name }
    end
    alias :[] :find_by_name

    # Public: Add a 'weapon' to the arsenal.
    #
    # weapon - An object that responds to a name method e.g 'weapon.name' .
    #
    # Examples
    #
    #   Arsenal.actions.add(<Action>) # => <Action>
    #
    # Returns the weapon passed.
    def add(weapon)
      if weapon.ok?
        remove weapon.name
        self << weapon 
      end
      weapon
    end

    # Public: Removes a 'weapon' from the arsenal.
    #
    # name - The name of the arsenal to delete.
    #
    # Examples
    #
    #   Arsenal.actions.remove(:my_action) # => [<Action>]
    #
    # Returns self.
    def remove(name)
      self.delete_if {|w| w.name == name}
    end

    # Public: Clears the arsenals storage array.
    #
    # Examples
    #
    #   Arsenal.strategies.clear! # => []
    #
    # Returns an empty array.
    def clear!
      self.clear
    end

    class << self

      # Public: Storage for the defined strategies.
      #
      # Examples
      #
      #   Arsenal.strategies # => [<Strategy>, <Strategy>]
      #
      # Returns the strategies arsenal.
      def strategies
        @strategies ||= new
      end

      # Public: Storage for the defined actions.
      #
      # Examples
      #
      #   Arsenal.actions # => [<Action>, <Action>]
      #
      # Returns the actions arsenal.
      def actions
        @actions ||= new
      end

      # Public: Clears the arsenals storage of all strategies and actions.
      #
      # Examples
      #
      #   Arsenal.reset! # => true
      #
      # Returns true.
      def reset!
        @strategies, @actions = nil
        true
      end

    end
    
  end

end