# encoding: utf-8

require 'spec_helper'
require 'trooper/actions/setup_trooper_action'

describe "RestartServerAction" do

  before do
    @action = Trooper::Actions::SetupTrooperAction.new
    @config = { :path => '/path', :trooper_path => '/path/trooper' }
  end

  it "should be named restart_server" do
    @action.name.should == :setup_trooper
  end

  it "should return an array of commands" do
    @action.call(@config).should == ["mkdir -p /path", "mkdir -p /path/trooper", "echo -e \"Trooper Setup on Server!\""]
  end

end