module Trooper
  module Config
    module Environment

      def set(value)
        nil
      end
      
      def env(environment_name, &block)
        instance_variable_set "@#{environment_name.to_s}_configuration", block
      end

      def user(arg)
        set :user => arg 
      end

      def hosts(*arg)
        set :hosts => [*arg] 
      end

      def repository(arg)
        set :repository => arg 
      end

      def path(arg)
        set :application_path => "#{arg}/application" 
        set :trooper_path => "#{arg}/trooper"
        set :path => arg 
      end

    end
  end
end