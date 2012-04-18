module Trooper
  module DSL
    module Rake
      
      def rake(command)
        run "#{ruby_bin_path}rake #{command}"
      end
      
    end
  end
end