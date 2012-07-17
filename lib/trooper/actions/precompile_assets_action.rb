require 'trooper/actions/default_action'

module Trooper
  module Actions

    class PrecompileAssetsAction < DefaultAction
      name :precompile_assets
      description "Precompile Application Assets"
      options :local => true, :on => :first_host

      private

      def build_commands
        run "bundle exec rake assets:precompile RAILS_ENV=production RAILS_GROUPS=assets"
      end
      
    end
    
  end
end