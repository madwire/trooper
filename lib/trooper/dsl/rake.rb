module Trooper
  module DSL
    module Rake
      
      def rake(command)
        run "rake #{command}"
      end
      
    end
  end
end