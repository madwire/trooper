
module Trooper
  module DSL
    module Bundler
      
      def bundle_exec(command)
        use_bundle = using_bundler? ? "bundle exec " : ""
        run use_bundle + command
      end

      def bundle_install
        run "bundle install --path #{path}/trooper/bundle --deployment --without development test" if using_bundler?
      end
      
      private
      
      def using_bundler?
        File.exists? "Gemfile"
      end
      
    end
  end
end