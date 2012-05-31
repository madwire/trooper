module Trooper
  module Config
    module Environment

      def load_environment!
        instance_variable = instance_variable_get("@#{self[:environment].to_s}_configuration")
        unless instance_variable.nil?
          instance_eval(&instance_variable)
        end
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
        set :prerequisite_list => "#{arg}/trooper/prerequisite_list"
        set :path => arg 
      end

      def ruby_bin_path(arg)
        set :ruby_bin_path => arg.gsub(/[^\/]$/, '\1/') # /usr/local/bin/
      end

    end
  end
end