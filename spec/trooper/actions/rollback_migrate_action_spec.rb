# encoding: utf-8

require 'spec_helper'
require 'trooper/actions/rollback_migrate_action'

describe "RollbackMigrateAction" do

  before do
    @action = Trooper::Actions::RollbackMigrateAction.new
    @config = { :application_path => '/path/to/application', :environment => :production, :hosts => ['A', 'B'] }
  end

  it "should be named rollback_migrate" do
    @action.name.should == :rollback_migrate
  end

  it "should return an array of commands" do
    @action.call(@config).should == ["cd /path/to/application", "bundle exec rake db:rollback RAILS_ENV=production"]
  end

  it "should return an array of commands for the first host only" do
    @action.call(@config).count.should == 2
    @action.call(@config).count.should == 0
  end

end