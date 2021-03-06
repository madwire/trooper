require 'trooper/action'

require 'trooper/actions/clone_repository_action'
require 'trooper/actions/install_gems_action'
require 'trooper/actions/migrate_database_action'
require 'trooper/actions/prepare_prerequisite_action'
require 'trooper/actions/restart_server_action'
require 'trooper/actions/rollback_migrate_action'
require 'trooper/actions/setup_database_action'
require 'trooper/actions/setup_trooper_action'
require 'trooper/actions/update_repository_action'
require 'trooper/actions/precompile_assets_action'

module Trooper
  module Config
    module Action

      DEFAULT_ACTIONS = [Actions::SetupTrooperAction, Actions::PreparePrerequisiteAction,
                          Actions::CloneRepositoryAction, Actions::InstallGemsAction, 
                          Actions::MigrateDatabaseAction, Actions::RestartServerAction, 
                          Actions::RollbackMigrateAction, Actions::SetupDatabaseAction, 
                          Actions::UpdateRepositoryAction, Actions::PrecompileAssetsAction]
      
      def action(name, description = "No Description", options = {}, &block)
        action = Trooper::Action.new name, description, options, &block
        action.config = self

        Trooper::Arsenal.actions.add action
      end


      def load_default_actions!
        DEFAULT_ACTIONS.each do |klass|
          Trooper.logger.debug "loaded #{klass.to_s}"
          Trooper::Arsenal.actions.add klass.new
        end
      end

    end
  end
end