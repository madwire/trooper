# encoding: utf-8

require 'spec_helper'
require 'trooper/actions/rollback_migrate_action'

describe "RollbackMigrateAction" do

  before do
    @action = Trooper::Actions::RollbackMigrateAction.new
    @config = { :application_path => '/path/to/application', :environment => :production }
  end

  it "should be named rollback_migrate" do
    @action.name.should == :rollback_migrate
  end

  it "should return an array of commands" do
    @action.call(@config).should == ["cd /path/to/application", "bundle exec rake db:rollback RAILS_ENV=production"]
  end

end