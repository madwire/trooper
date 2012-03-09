# encoding: utf-8

require 'spec_helper'
require 'trooper/actions/install_gems_action'

describe "InstallGemsAction" do

  before do
    @action = Trooper::Actions::InstallGemsAction.new :application_path => '/path/to/application', :trooper_path => '/path/to/trooper'
  end

  it "should return an array of commands" do
    @action.commands.should == ["cd /path/to/application", "bundle install --path /path/to/trooper/bundle --deployment --without development test"]
  end

end