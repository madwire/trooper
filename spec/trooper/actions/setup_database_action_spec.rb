# encoding: utf-8

require 'spec_helper'
require 'trooper/actions/setup_database_action'

describe "SetupDatabaseAction" do

  before do
    @action = Trooper::Actions::SetupDatabaseAction.new
    @config = { :application_path => '/path/to/application', :environment => :production }
  end

  it "should be named setup_database" do
    @action.name.should == :setup_database
  end

  it "should return an array of commands" do
    @action.call(@config).should == ["cd /path/to/application", "bundle exec rake db:setup RAILS_ENV=production"]
  end

end