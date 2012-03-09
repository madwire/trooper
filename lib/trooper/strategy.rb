module Trooper
  class Strategy

    attr_reader :name, :description
    
    def initialize(name, description, config = {}, &block)
      @name, @description, @config = name, description, config
    end

    def ok?
      true
    end

  end
end