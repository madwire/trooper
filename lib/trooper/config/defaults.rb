require 'trooper/config/action'

module Trooper
  module Config
    module Defaults
      FILE_NAME = "Troopfile"
      
      include Trooper::Config::Action

      def load_defaults!(options = {})
        config[:file_name] = options[:file_name] || FILE_NAME
        config[:environment] = options[:environment] || :production
        config[:ruby_bin_path] = options[:ruby_bin_path] || ""
        
        load_default_actions!
      end

    end
  end
end