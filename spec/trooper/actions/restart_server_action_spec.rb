# encoding: utf-8

require 'spec_helper'
require 'trooper/actions/restart_server_action'

describe "RestartServerAction" do

  before do
    @action = Trooper::Actions::RestartServerAction.new
    @config = { :application_path => '/path/to/application' }
  end

  it "should be named restart_server" do
    @action.name.should == :restart_server
  end

  it "should return an array of commands" do
    @action.call(@config).should == ["cd /path/to/application", "mkdir -p tmp", "touch tmp/restart.txt", "echo -e \"Server restarted!\""]
  end

end