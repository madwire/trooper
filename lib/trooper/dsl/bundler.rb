module Trooper
  module DSL
    module Bundler
      
      def bundle_exec(command)
        use_bundle = using_bundler? ? "#{ruby_bin_path}bundle exec " : ""
        run use_bundle + command
      end

      def bundle_install
        run "#{ruby_bin_path}bundle install --path #{trooper_path}/bundle --deployment --without development test" if using_bundler?
      end

      def rake(command)
        bundle_exec "rake #{command}"
      end
      
      private
      
      def using_bundler?
        File.exists? "Gemfile"
      end

      def ruby_bin_path
        config[:ruby_bin_path] || ""
      end
      
    end
  end
end