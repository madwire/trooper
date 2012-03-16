# encoding: utf-8

require 'spec_helper'
require 'trooper/actions/install_gems_action'

describe "InstallGemsAction" do

  before do
    @action = Trooper::Actions::InstallGemsAction.new
    @config = { :application_path => '/path/to/application', :trooper_path => '/path/to/trooper' }
  end

  it "should be named install_gems" do
    @action.name.should == :install_gems
  end

  it "should return an array of commands" do
    @action.call(@config).should == ["cd /path/to/application", "bundle install --path /path/to/trooper/bundle --deployment --without development test"]
  end

end