module Trooper
  module DSL
    module Rake
      
      def rake(command)
        run "#{ruby_bin_path}rake #{command}"
      end

      private

      def ruby_bin_path
        config[:ruby_bin_path] || ""
      end
      
    end
  end
end