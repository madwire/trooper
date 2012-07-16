# encoding: utf-8

require 'spec_helper'
require 'trooper/actions/migrate_database_action'

describe "MigrateDatabaseAction" do

  before do
    @action = Trooper::Actions::MigrateDatabaseAction.new
    @config = { :application_path => '/path/to/application', :environment => :production, :hosts => ['A', 'B'] }
  end

  it "should be named migrate_database" do
    @action.name.should == :migrate_database
  end

  it "should return an array of commands" do
    @action.call(@config).should == ["cd /path/to/application", "bundle exec rake db:migrate RAILS_ENV=production"]
  end

  it "should return an array of commands for the first host only" do
    @action.call(@config).count.should == 2
    @action.call(@config).count.should == 0
  end

end