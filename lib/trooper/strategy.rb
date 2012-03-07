module Trooper
  class Strategy

    attr_reader :name, :description
    
    def initialize(name, description, &block)
      @name, @description = name, description
    end

    def ok?
      true
    end

  end
end